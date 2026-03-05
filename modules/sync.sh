#!/bin/bash
# Bifrost Sync Module - Unified System Updates

sync_system() {
    echo -e "${CYAN}--- Synchronizing System ---${NC}"
    
    if [ "$DISTRO" == "arch" ]; then
        echo -e "${CYAN}Running Pacman Update...${NC}"
        sudo pacman -Syu --noconfirm
        
        if command -v yay >/dev/null 2>&1; then
            echo -e "${CYAN}Running YAY (AUR) Update...${NC}"
            yay -Sua --noconfirm
        fi
        
        if command -v paccache >/dev/null 2>&1; then
            echo -e "${CYAN}Cleaning Pacman Cache (keeping 2 versions)...${NC}"
            sudo paccache -rk2
        fi
        
    elif [ "$DISTRO" == "debian" ]; then
        echo -e "${CYAN}Running APT Update & Upgrade...${NC}"
        sudo apt update
        sudo apt upgrade -y
        sudo apt dist-upgrade -y
        sudo apt autoremove -y
    fi

    if command -v fwupdmgr >/dev/null 2>&1; then
        echo -e "${CYAN}Checking for Firmware Updates (fwupd)...${NC}"
        sudo fwupdmgr refresh --force
        sudo fwupdmgr get-updates
    fi

    if command -v flatpak >/dev/null 2>&1; then
        echo -e "${CYAN}Syncing Flatpaks...${NC}"
        flatpak update -y
    fi

    echo -e "${GREEN}System Synchronization Complete.${NC}"
}
