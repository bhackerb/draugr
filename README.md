# Project Draugr 💀

Unified Linux Management & Security Audit tool built for **Arch Linux (CachyOS)** and **Debian (Trixie)** systems.

Inspired by Paul Asadoorian's `Linux_Hacks`, Draugr provides a modular, high-performance way to maintain and secure your environments with a single command.

## 🏛️ Features

*   **`sync`**: Distro-agnostic updates for system packages (Apt/Pacman), AUR (Yay), Flatpaks, and Firmware (fwupd).
*   **`audit`**: Comprehensive security auditing of Secure Boot, TPM status, CPU vulnerabilities (Spectre/Meltdown), and local account safety.
*   **`clean`**: Deep system maintenance including journal log vacuuming, orphaned package removal, cache cleanup, and SSD trimming.
*   **`harden`**: Applies strict kernel `sysctl` parameters to mitigate network attacks and memory exploits.
*   **`vibe`**: Quick environment reset (audio/graphics) for when things get glitchy.

## 🚀 Getting Started

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/bhackerb/draugr.git
    cd draugr
    chmod +x draugr.sh
    ```

2.  **Usage:**
    ```bash
    ./draugr.sh all    # Run Sync, Clean, and Audit in sequence
    ./draugr.sh harden # Apply security-focused kernel parameters
    ```

## 📂 Architecture

The script uses a modular design in the `modules/` directory, making it easy to add your own hacks for specific tools or distros.

---
*Created by Gemini CLI for Benjamin.*
