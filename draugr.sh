#!/bin/bash

# Project "Draugr" - Unified Linux Management & Security Audit
# Inspired by Paul Asadoorian's Linux Hacks
# Built for Debian (Trixie) & Arch (CachyOS)

# --- Configuration & Variables ---
BASE_DIR=$(dirname $(readlink -f "$0"))
MODULE_DIR="$BASE_DIR/modules"

# --- Distro Detection ---
if [ -f /etc/arch-release ]; then
    DISTRO="arch"
    PKG_MGR="pacman"
elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
    PKG_MGR="apt"
else
    echo "ERROR: Unsupported distro. Draugr only supports Arch and Debian."
    exit 1
fi

# --- Vibe Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Module Loader ---
load_modules() {
    for module in "$MODULE_DIR"/*.sh; do
        if [ -f "$module" ]; then
            source "$module"
        fi
    done
}

load_modules

# --- Banner ---
show_banner() {
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}         PROJECT DRAUGR v2.0            ${NC}"
    echo -e "${RED}========================================${NC}"
    echo -e "Detected Distro: ${GREEN}${DISTRO}${NC} (via ${PKG_MGR})"
    echo ""
}

# --- Main Entry Point ---
case "$1" in
    sync)
        show_banner
        sync_system
        ;;
    audit)
        show_banner
        audit_security
        ;;
    clean)
        show_banner
        cleanup_system
        ;;
    harden)
        show_banner
        harden_system
        ;;
    vibe)
        show_banner
        echo -e "${CYAN}Resetting the environment for maximum metal...${NC}"
        if command -v pipewire >/dev/null 2>&1; then
            systemctl --user restart pipewire pipewire-pulse wireplumber
            echo -e "${GREEN}Pipewire Restored.${NC}"
        fi
        ;;
    all)
        show_banner
        sync_system
        cleanup_system
        audit_security
        ;;
    *)
        show_banner
        echo "Usage: draugr {sync|audit|clean|harden|vibe|all}"
        echo ""
        echo "Commands:"
        echo "  sync    - Update system packages, AUR, flatpaks, and firmware."
        echo "  audit   - Security audit (Secure Boot, TPM, Vulnerabilities, Accounts)."
        echo "  clean   - Deep clean (Journal logs, package cache, orphans, SSD trim)."
        echo "  harden  - Apply security-focused kernel (sysctl) parameters."
        echo "  vibe    - Quick fix for common audio/graphics issues."
        echo "  all     - Run sync, clean, and audit in sequence."
        exit 1
        ;;
esac
