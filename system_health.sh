#!/bin/bash

# =======================================
#      SYSTEM HEALTH CHECKER v1.0
# =======================================

# ----- Colors -----
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# ----- Banner -----
banner() {
    echo -e "${BLUE}======================================="
    echo -e "      SYSTEM HEALTH CHECKER v1.0"
    echo -e "=======================================${RESET}"
}

# ----- Logging -----
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
log_file="system_health_${timestamp}.txt"

log() {
    echo -e "$1" | tee -a "$log_file"
}

# ----- CPU Check -----
cpu_check() {
    log "${YELLOW}[CPU CHECK]${RESET}"
    top -bn1 | grep "Cpu(s)" | tee -a "$log_file"
    echo "" | tee -a "$log_file"
}

# ----- Memory Check -----
memory_check() {
    log "${YELLOW}[MEMORY CHECK]${RESET}"
    free -h | tee -a "$log_file"
    echo "" | tee -a "$log_file"
}

# ----- Disk Check -----
disk_check() {
    log "${YELLOW}[DISK CHECK]${RESET}"
    df -h | tee -a "$log_file"
    echo "" | tee -a "$log_file"
}

# ----- Process Check -----
process_check() {
    log "${YELLOW}[TOP PROCESSES]${RESET}"
    ps aux --sort=-%cpu | head -n 10 | tee -a "$log_file"
    echo "" | tee -a "$log_file"
}

# ----- Help Menu -----
show_help() {
    echo -e "${GREEN}Usage: ./system_health.sh [OPTIONS]${RESET}"
    echo ""
    echo "Options:"
    echo "  --cpu         Run CPU check"
    echo "  --memory      Run memory check"
    echo "  --disk        Run disk check"
    echo "  --processes   Show top processes"
    echo "  --all         Run all checks"
    echo "  --help        Show this help menu"
    echo "  --version     Show script version"
}

# ----- Version -----
show_version() {
    echo "System Health Checker v1.0"
}

# ----- Main Logic -----
banner
log "===== SYSTEM HEALTH CHECK ($timestamp) ====="

case "$1" in
    --cpu) cpu_check ;;
    --memory) memory_check ;;
    --disk) disk_check ;;
    --processes) process_check ;;
    --all)
        cpu_check
        memory_check
        disk_check
        process_check
        ;;
    --help) show_help ;;
    --version) show_version ;;
    *)
        echo -e "${RED}[!] Invalid option. Use --help for usage.${RESET}"
        ;;
esac

echo -e "${GREEN}[+] Health check complete. Log saved to ${log_file}${RESET}"
