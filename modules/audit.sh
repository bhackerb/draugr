#!/bin/bash
# Bifrost Audit Module - Security and Supply Chain

audit_security() {
    echo -e "${RED}--- SECURITY AUDIT ---${NC}"
    
    # 1. Supply Chain Foundation
    echo -n "Checking Secure Boot: "
    if command -v mokutil >/dev/null 2>&1; then
        mokutil --sb-state
    else
        echo -e "${YELLOW}mokutil not found. Cannot verify SB state.${NC}"
    fi
    
    echo -n "Checking TPM: "
    if [ -d /sys/class/tpm/tpm0 ]; then
        echo -e "${GREEN}TPM 2.0 found.${NC}"
    else
        echo -e "${YELLOW}TPM not found or disabled in UEFI.${NC}"
    fi

    # 2. Kernel and Vulnerabilities
    echo -n "Checking CPU Microcode: "
    grep -i "microcode" /proc/cpuinfo | head -1
    
    echo -e "${CYAN}Checking Mitigation Status for Major Vulnerabilities...${NC}"
    grep . /sys/devices/system/cpu/vulnerabilities/* | sed 's|^/sys/devices/system/cpu/vulnerabilities/||' | column -t -s ':'

    # 3. User and Account Security
    echo -e "${CYAN}Checking for UID 0 Users (other than root)...${NC}"
    EXTRA_ROOTS=$(awk -F: '($3 == "0" && $1 != "root") {print $1}' /etc/passwd)
    if [ -n "$EXTRA_ROOTS" ]; then
        echo -e "${RED}WARNING: Additional root accounts found: $EXTRA_ROOTS${NC}"
    else
        echo -e "${GREEN}Only 'root' has UID 0.${NC}"
    fi

    echo -e "${CYAN}Checking for Accounts with Empty Passwords...${NC}"
    EMPTY_PW=$(sudo awk -F: '($2 == "") {print $1}' /etc/shadow)
    if [ -n "$EMPTY_PW" ]; then
        echo -e "${RED}WARNING: Accounts with empty passwords found: $EMPTY_PW${NC}"
    else
        echo -e "${GREEN}No accounts with empty passwords found.${NC}"
    fi

    # 4. Service and SSH Security
    echo -e "${CYAN}Checking SSH Root Login Status...${NC}"
    if [ -f /etc/ssh/sshd_config ]; then
        ROOT_LOGIN=$(grep "^PermitRootLogin" /etc/ssh/sshd_config | awk '{print $2}')
        if [[ "$ROOT_LOGIN" == "yes" ]]; then
            echo -e "${RED}WARNING: PermitRootLogin is set to YES.${NC}"
        else
            echo -e "${GREEN}PermitRootLogin is $ROOT_LOGIN (Recommended: no/prohibit-password).${NC}"
        fi
    else
        echo -e "${YELLOW}SSH Config not found.${NC}"
    fi

    # 5. Firewall Check
    echo -e "${CYAN}Checking Firewall Status...${NC}"
    if command -v ufw >/dev/null 2>&1; then
        sudo ufw status | head -n 1
    elif command -v nft >/dev/null 2>&1; then
        sudo nft list ruleset | head -n 1 | grep -q "table" && echo "nftables active" || echo "nftables found, but empty."
    else
        echo -e "${RED}WARNING: No active firewall (ufw/nftables) detected.${NC}"
    fi

    echo -e "${GREEN}Audit Complete.${NC}"
}
