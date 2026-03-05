#!/bin/bash
# Bifrost Cleanup Module - System Deep Clean

cleanup_system() {
    echo -e "${CYAN}--- Cleaning System ---${NC}"
    
    # 1. Journal Log Vacuuming
    echo -e "${CYAN}Vacuuming Journal Logs (keeping 2 days)...${NC}"
    sudo journalctl --vacuum-time=2d
    
    # 2. Distro-Specific Cleanup
    if [ "$DISTRO" == "arch" ]; then
        echo -e "${CYAN}Cleaning Orphaned Packages (Arch)...${NC}"
        ORPHANS=$(pacman -Qtdq)
        if [ -n "$ORPHANS" ]; then
            sudo pacman -Rns $ORPHANS --noconfirm
        else
            echo "No orphaned packages found."
        fi
        
        if command -v paccache >/dev/null 2>&1; then
            echo -e "${CYAN}Cleaning Pacman Cache (keeping 2 versions)...${NC}"
            sudo paccache -rk2
            sudo paccache -ruk0 # Remove all uninstalled package versions
        fi
        
    elif [ "$DISTRO" == "debian" ]; then
        echo -e "${CYAN}Cleaning Debian Cache...${NC}"
        sudo apt autoremove -y
        sudo apt autoclean
        
        if command -v deborphan >/dev/null 2>&1; then
            echo -e "${CYAN}Cleaning Orphaned Packages (Debian)...${NC}"
            ORPHANS=$(deborphan)
            if [ -n "$ORPHANS" ]; then
                sudo apt-get remove --purge $ORPHANS -y
            fi
        fi
    fi

    # 3. SSD Trim
    if [ -f /usr/sbin/fstrim ]; then
        echo -e "${CYAN}Running SSD Trim...${NC}"
        sudo fstrim -av
    fi

    # 4. Failed systemd services
    echo -e "${CYAN}Checking for Failed systemd Services...${NC}"
    FAILED_UNITS=$(systemctl --failed --no-pager --plain)
    if [[ "$FAILED_UNITS" == *"0 loaded units listed"* ]]; then
        echo -e "${GREEN}No failed systemd services found.${NC}"
    else
        echo -e "$FAILED_UNITS"
        echo -e "${YELLOW}Hint: Use 'sudo systemctl reset-failed' to clear these if they are harmless (like plymouth-quit).${NC}"
    fi

    echo -e "${GREEN}System Cleanup Complete.${NC}"
}
