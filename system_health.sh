#!/bin/bash

# ===== Colors =====
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"
# ===== Command Checks =====
for cmd in free df ps uptime; do
    if ! command -v $cmd >/dev/null 2>&1; then
        echo -e "${RED}Error: Required command '$cmd' not found.${RESET}"
        exit 1
    fi
done


timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
logfile="system_health_$timestamp.txt"

echo -e "${BLUE}"
echo "======================================="
echo "      SYSTEM HEALTH CHECKER v1.0       "
echo "======================================="
echo -e "${RESET}"

help_menu() {
    echo -e "${YELLOW}System Health Checker${RESET}"
    echo -e "Usage: $0 [options]\n"
    echo -e "Options:"
    echo -e "  --cpu         Show CPU load"
    echo -e "  --memory      Show memory usage"
    echo -e "  --disk        Show disk usage"
    echo -e "  --processes   Show top processes"
    echo -e "  --all         Run all checks"
    echo -e "  --help        Show this help menu"
}

if [[ "$1" == "--no-color" ]]; then
    RED=""; GREEN=""; YELLOW=""; BLUE=""; RESET=""
    shift
fi

cpu_check() {
echo -e "\n${BLUE}[+] CPU Load:${RESET}" | tee -a "$logfile"
    uptime | tee -a "$logfile"
}

memory_check() {
echo -e "\n${BLUE}[+] Memory Usage:${RESET}" | tee -a "$logfile"
    free -h | tee -a "$logfile"
}

disk_check() {
echo -e "\n${BLUE}[+] Disk Usage:${RESET}" | tee -a "$logfile"
    df -h | tee -a "$logfile"
}

process_check() {
echo -e "\n${BLUE}[+] Top 5 Processes by CPU:${RESET}" | tee -a "$logfile"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | tee -a "$logfile"

echo -e "\n${BLUE}[+] Top 5 Processes by Memory:${RESET}" | tee -a "$logfile"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tee -a "$logfile"
}

usage() {
    echo "Usage: $0 [--cpu] [--memory] [--disk] [--processes] [--all]"
}

if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

echo "===== SYSTEM HEALTH CHECK ($timestamp) =====" | tee -a "$logfile"

for arg in "$@"; do
    case $arg in
        --cpu) cpu_check ;;
        --memory) memory_check ;;
        --disk) disk_check ;;
        --processes) process_check ;;
        --all) cpu_check; memory_check; disk_check; process_check ;;
	--help) help_menu; exit 0 ;;
	--version) echo "System Health Checker v1.0"; exit 0 ;;        
*) echo "Unknown option: $arg"; usage; exit 1 ;;
    esac
done

echo -e "\n${GREEN}[+] Health check complete. Log saved to $logfile${RESET}" | tee -a "$logfile"
