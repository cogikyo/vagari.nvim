#!/usr/bin/env bash
# Deploy script: heredocs, arrays, getopts, pipes, process substitution.

set -euo pipefail

# --- Option parsing ----------------------------------------------------------

ENVIRONMENT="staging"
DRY_RUN=false
SERVICES=()
ROLLBACK=false
VERBOSE=false

usage() {
    cat <<-'EOF'
	Usage: deploy.sh [OPTIONS] [SERVICE...]

	Options:
	  -e ENV     Target environment (staging|production) [default: staging]
	  -n         Dry run — show what would be deployed
	  -r         Rollback to previous version
	  -v         Verbose output
	  -h         Show this help

	Examples:
	  deploy.sh -e production api worker
	  deploy.sh -n -e staging
	  deploy.sh -r -e production api
	EOF
}

while getopts ":e:nrvh" opt; do
    case $opt in
        e) ENVIRONMENT="$OPTARG" ;;
        n) DRY_RUN=true ;;
        r) ROLLBACK=true ;;
        v) VERBOSE=true ;;
        h) usage; exit 0 ;;
        :) echo "Option -${OPTARG} requires an argument" >&2; exit 1 ;;
        \?) echo "Unknown option: -${OPTARG}" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# Remaining args are service names
SERVICES=("${@:-api worker scheduler}")

# --- Validation --------------------------------------------------------------

declare -A ENV_CLUSTERS=(
    [staging]="k8s-staging-usw2"
    [production]="k8s-prod-usw2"
)

if [[ ! -v "ENV_CLUSTERS[$ENVIRONMENT]" ]]; then
    echo "Unknown environment: $ENVIRONMENT" >&2
    echo "Valid: ${!ENV_CLUSTERS[*]}" >&2
    exit 1
fi

CLUSTER="${ENV_CLUSTERS[$ENVIRONMENT]}"

# --- Deploy functions --------------------------------------------------------

get_current_version() {
    local service="$1"
    # Simulate kubectl query with process substitution
    grep -oP "image: \K[^\"']+" < <(
        cat <<-YAML
		containers:
		  - name: ${service}
		    image: registry.example.com/${service}:v1.42.0
		    ports:
		      - containerPort: 8080
		YAML
    ) || echo "unknown"
}

get_deploy_version() {
    local service="$1"
    git log -1 --format='%h' -- "services/${service}/" 2>/dev/null || echo "HEAD"
}

deploy_service() {
    local service="$1"
    local version="$2"

    local current
    current=$(get_current_version "$service")

    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would deploy ${service}: ${current} → ${version}"
        return 0
    fi

    echo "Deploying ${service} to ${CLUSTER}..."
    echo "  Current: ${current}"
    echo "  Target:  ${version}"

    # Simulate deployment with a heredoc for the manifest
    local manifest
    manifest=$(cat <<-YAML
	apiVersion: apps/v1
	kind: Deployment
	metadata:
	  name: ${service}
	  namespace: ${ENVIRONMENT}
	  labels:
	    app: ${service}
	    version: "${version}"
	    deployed-by: "${USER:-ci}"
	spec:
	  replicas: $( [[ "$ENVIRONMENT" == "production" ]] && echo 3 || echo 1 )
	  template:
	    spec:
	      containers:
	        - name: ${service}
	          image: registry.example.com/${service}:${version}
	          env:
	            - name: ENVIRONMENT
	              value: "${ENVIRONMENT}"
	YAML
    )

    if [[ "$VERBOSE" == true ]]; then
        echo "$manifest"
    fi

    echo "  ✓ ${service} deployed successfully"
}

rollback_service() {
    local service="$1"
    echo "Rolling back ${service} on ${CLUSTER}..."

    # Pipe chain: get history, filter, pick previous
    local previous
    previous=$(echo "v1.41.0 v1.42.0" | tr ' ' '\n' | tail -n 2 | head -n 1)

    deploy_service "$service" "$previous"
}

# --- Main --------------------------------------------------------------------

echo "═══════════════════════════════════════════"
echo "  Deploy to ${ENVIRONMENT} (cluster: ${CLUSTER})"
echo "  Services: ${SERVICES[*]}"
[[ "$DRY_RUN" == true ]] && echo "  Mode: DRY RUN"
[[ "$ROLLBACK" == true ]] && echo "  Mode: ROLLBACK"
echo "═══════════════════════════════════════════"
echo

failed=0
for service in "${SERVICES[@]}"; do
    if [[ "$ROLLBACK" == true ]]; then
        rollback_service "$service" || ((failed++))
    else
        version=$(get_deploy_version "$service")
        deploy_service "$service" "$version" || ((failed++))
    fi
done

echo
if [[ $failed -gt 0 ]]; then
    echo "${failed} service(s) failed to deploy" >&2
    exit 1
else
    echo "All services deployed successfully"
fi
