# Terraform: providers, resources, variables, outputs, data sources, modules.

terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "s3" {
    bucket         = "vagari-terraform-state"
    key            = "infra/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "vagari"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# --- Variables ---------------------------------------------------------------

variable "region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Environment must be staging or production."
  }
}

variable "db_instance_class" {
  description = "RDS instance size"
  type        = string
  default     = "db.t3.medium"
}

variable "container_config" {
  description = "ECS container settings"
  type = object({
    cpu    = number
    memory = number
    count  = number
    port   = number
  })
  default = {
    cpu    = 512
    memory = 1024
    count  = 2
    port   = 8080
  }
}

# --- Locals ------------------------------------------------------------------

locals {
  name_prefix = "vagari-${var.environment}"
  common_tags = {
    Service = "api"
    Team    = "platform"
  }

  container_env = [
    { name = "ENVIRONMENT", value = var.environment },
    { name = "LOG_LEVEL", value = var.environment == "production" ? "info" : "debug" },
    { name = "PORT", value = tostring(var.container_config.port) },
  ]
}

# --- Data sources ------------------------------------------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "db_password" {
  name            = "/${local.name_prefix}/db/password"
  with_decryption = true
}

# --- Networking --------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${local.name_prefix}-private-${count.index + 1}"
    Tier = "private"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 100)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-${count.index + 1}"
    Tier = "public"
  }
}

# --- Security ----------------------------------------------------------------

resource "aws_security_group" "api" {
  name_prefix = "${local.name_prefix}-api-"
  vpc_id      = aws_vpc.main.id
  description = "Security group for API containers"

  ingress {
    description = "HTTP from ALB"
    from_port   = var.container_config.port
    to_port     = var.container_config.port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --- Database ----------------------------------------------------------------

resource "random_id" "db_suffix" {
  byte_length = 4
}

resource "aws_db_instance" "main" {
  identifier     = "${local.name_prefix}-db-${random_id.db_suffix.hex}"
  engine         = "postgres"
  engine_version = "16.1"
  instance_class = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true

  db_name  = "vagari"
  username = "vagari"
  password = data.aws_ssm_parameter.db_password.value

  vpc_security_group_ids = [aws_security_group.api.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = var.environment == "production" ? 30 : 7
  deletion_protection     = var.environment == "production"
  skip_final_snapshot     = var.environment != "production"

  tags = local.common_tags
}

resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db"
  subnet_ids = aws_subnet.private[*].id
}

# --- Outputs -----------------------------------------------------------------

output "vpc_id" {
  description = "VPC identifier"
  value       = aws_vpc.main.id
}

output "db_endpoint" {
  description = "RDS connection endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
