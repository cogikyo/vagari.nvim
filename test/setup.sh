#!/usr/bin/env bash
# Setup script: functions, conditionals, variable expansion, traps, arrays.

set -euo pipefail
IFS=$'\n\t'

# --- Constants ---------------------------------------------------------------

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="${SCRIPT_DIR}/install.log"
readonly REQUIRED_CMDS=(git curl jq tar)
readonly MIN_NODE_VERSION=18
readonly CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/vagari"

# Colors (only if terminal supports them)
if [[ -t 1 ]] && command -v tput &>/dev/null; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    RED="" GREEN="" YELLOW="" BOLD="" RESET=""
fi

# --- Logging -----------------------------------------------------------------

log()   { printf '%s[%s]%s %s\n' "$GREEN" "$(date +%H:%M:%S)" "$RESET" "$*"; }
warn()  { printf '%s[WARN]%s %s\n' "$YELLOW" "$RESET" "$*" >&2; }
error() { printf '%s[ERROR]%s %s\n' "$RED" "$RESET" "$*" >&2; }
die()   { error "$@"; exit 1; }

# --- Cleanup trap ------------------------------------------------------------

cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        error "Installation failed (exit code: $exit_code)"
        error "Check log: $LOG_FILE"
    fi
    # Remove temp files
    rm -rf "${TMPDIR:-/tmp}/vagari-install-$$"
}
trap cleanup EXIT

# --- Dependency checks -------------------------------------------------------

check_dependencies() {
    local missing=()

    for cmd in "${REQUIRED_CMDS[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        die "Missing required commands: ${missing[*]}"
    fi

    # Check Node.js version
    if command -v node &>/dev/null; then
        local node_version
        node_version=$(node --version | sed 's/v//' | cut -d. -f1)
        if [[ "$node_version" -lt "$MIN_NODE_VERSION" ]]; then
            warn "Node.js ${node_version} found, but ${MIN_NODE_VERSION}+ recommended"
        fi
    fi

    log "All dependencies satisfied"
}

# --- Platform detection ------------------------------------------------------

detect_platform() {
    local os arch

    case "$(uname -s)" in
        Linux*)  os="linux" ;;
        Darwin*) os="darwin" ;;
        MINGW*|MSYS*) os="windows" ;;
        *) die "Unsupported OS: $(uname -s)" ;;
    esac

    case "$(uname -m)" in
        x86_64|amd64)  arch="amd64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) die "Unsupported architecture: $(uname -m)" ;;
    esac

    printf '%s_%s' "$os" "$arch"
}

# --- Installation ------------------------------------------------------------

install_binary() {
    local platform="$1"
    local version="${2:-latest}"
    local dest="${3:-$HOME/.local/bin}"

    log "Installing for ${BOLD}${platform}${RESET} (version: ${version})"

    local tmpdir
    tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/vagari-install-$$-XXXXXX")

    local url="https://example.com/releases/${version}/vagari-${platform}.tar.gz"

    if ! curl -fsSL "$url" -o "${tmpdir}/release.tar.gz" 2>>"$LOG_FILE"; then
        die "Download failed: $url"
    fi

    tar -xzf "${tmpdir}/release.tar.gz" -C "$tmpdir"
    install -Dm755 "${tmpdir}/vagari" "${dest}/vagari"

    log "Installed to ${dest}/vagari"
    rm -rf "$tmpdir"
}

setup_config() {
    mkdir -p "$CONFIG_DIR"

    if [[ ! -f "${CONFIG_DIR}/config.toml" ]]; then
        cat > "${CONFIG_DIR}/config.toml" <<-'TOML'
		[theme]
		name = "vagari"
		variant = "dark"

		[editor]
		tab_size = 4
		wrap = false
		TOML
        log "Created default config at ${CONFIG_DIR}/config.toml"
    else
        log "Config already exists, skipping"
    fi
}

# --- Main --------------------------------------------------------------------

main() {
    log "Starting installation..."
    check_dependencies

    local platform
    platform=$(detect_platform)
    log "Detected platform: ${BOLD}${platform}${RESET}"

    install_binary "$platform" "${VERSION:-latest}" "${INSTALL_DIR:-$HOME/.local/bin}"
    setup_config

    log "${GREEN}${BOLD}Installation complete!${RESET}"
    log "Run 'vagari --help' to get started"
}

main "$@"
