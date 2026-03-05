#!/bin/bash
# Bifrost Harden Module - Kernel Hardening (sysctl)

harden_system() {
    echo -e "${RED}--- KERNEL HARDENING ---${NC}"
    
    SYSCTL_CONF="/etc/sysctl.d/99-bifrost-hardened.conf"
    
    echo -e "${CYAN}Creating/Updating $SYSCTL_CONF...${NC}"
    
    sudo bash -c "cat <<EOF > $SYSCTL_CONF
# --- Project Bifrost Hardened Kernel Parameters ---

# Network Hardening (Mitigate SYN floods, IP spoofing)
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Kernel/Memory Hardening (Mitigate exploits)
kernel.randomize_va_space = 2
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.unprivileged_bpf_disabled = 1
kernel.yama.ptrace_scope = 1
fs.suid_dumpable = 0
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
EOF"

    echo -e "${CYAN}Applying New Kernel Parameters...${NC}"
    sudo sysctl -p "$SYSCTL_CONF" || echo -e "${YELLOW}Some parameters failed to apply (this is common for certain kernels).${NC}"
    
    echo -e "${GREEN}Hardening Complete.${NC}"
}
