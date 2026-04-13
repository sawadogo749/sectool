#!/usr/bin/env bash

run_report() {
  REPORT_FILE="$REPORT_DIR/report_$(date +%Y%m%d_%H%M%S).txt"
  echo -e "\n${CYAN}[*] Generating report...${RESET}\n"

  {
    echo "========================================"
    echo "  SECTOOL — Security Report"
    echo "  Generated : $(date)"
    echo "  Hostname  : $(hostname)"
    echo "  OS        : $(uname -sr)"
    echo "  User      : $(whoami)"
    echo "========================================"
    echo ""

    echo "-- Audit --"
    if [ "${AUDIT_DONE:-0}" -eq 1 ]; then
      echo "  OK Audit ran at: ${AUDIT_TIMESTAMP:-unknown}"
    else
      echo "  !! Audit was not run"
    fi

    echo ""
    echo "-- Hardening --"
    if [ "${HARDENING_DONE:-0}" -eq 1 ]; then
      echo "  OK Hardening checks completed"
    else
      echo "  !! Hardening was not run"
    fi

    echo ""
    echo "-- System --"
    echo "  Uptime : $(uptime -p)"
    echo "  Memory : $(free -h | awk '/Mem:/{print $3 " used / " $2 " total"}')"
    echo "  Disk   : $(df -h / | awk 'NR==2{print $3 " used / " $2 " total"}')"

    echo ""
    echo "-- Open Ports --"
    ss -tuln | awk 'NR>1 {print "  " $1 "\t" $5}' | column -t

    echo ""
    echo "========================================"
    echo "  End of Report"
    echo "========================================"
  } | tee "$REPORT_FILE"

  echo -e "\n${GREEN}OK${RESET} Report saved: $REPORT_FILE"
}
