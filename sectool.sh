#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"
REPORT_DIR="$HOME/.sectool/reports"
mkdir -p "$REPORT_DIR"

banner() {
  echo -e "${CYAN}${BOLD}"
  echo "  =================================="
  echo "   SECTOOL - Security Audit Toolkit"
  echo "  =================================="
  echo -e "${RESET}"
}

menu() {
  echo -e "${BOLD}  What do you want to do?${RESET}\n"
  echo -e "  ${GREEN}[1]${RESET}  Audit"
  echo -e "  ${GREEN}[2]${RESET}  Hardening"
  echo -e "  ${GREEN}[3]${RESET}  Report"
  echo -e "  ${GREEN}[4]${RESET}  Full Run"
  echo -e "  ${GREEN}[5]${RESET}  Monitor"
  echo -e "  ${RED}[0]${RESET}  Exit\n"
  read -rp "  Your choice: " choice

  case "$choice" in
    1) source "$MODULES_DIR/audit.sh"     && run_audit ;;
    2) source "$MODULES_DIR/hardening.sh" && run_hardening ;;
    3) source "$MODULES_DIR/report.sh"    && run_report ;;
    4)
      source "$MODULES_DIR/audit.sh"     && run_audit
      source "$MODULES_DIR/hardening.sh" && run_hardening
      source "$MODULES_DIR/report.sh"    && run_report
      ;;
    5) source "$MODULES_DIR/monitor.sh"  && run_monitor ;;
    0) echo -e "\n  ${CYAN}Bye! Stay secure.${RESET}\n" ; exit 0 ;;
    *) echo -e "  ${RED}Invalid choice.${RESET}" ; menu ;;
  esac
}

banner
menu
