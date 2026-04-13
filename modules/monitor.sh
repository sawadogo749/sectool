#!/usr/bin/env bash

_section() { echo -e "\n${BOLD}${BLUE}== $1 ==${RESET}"; }
_ok()      { echo -e "  ${GREEN}OK${RESET} $1"; }
_warn()    { echo -e "  ${YELLOW}!!${RESET} $1"; }
_check_tool() { command -v "$1" &>/dev/null; }

run_monitor() {
  echo -e "\n${CYAN}[*] Starting monitor...${RESET}"
  echo -e "${YELLOW}    Press Ctrl+C to stop${RESET}\n"

  _section "System Info"
  echo -e "  Hostname : $(hostname)"
  echo -e "  OS       : $(uname -sr)"
  echo -e "  Uptime   : $(uptime -p)"

  _section "CPU & Memory"
  echo -e "  $(top -bn1 | grep 'Cpu(s)' | awk '{print "CPU usage : " $2 "%"}')"
  free -h | awk '/Mem:/{print "  RAM      : " $3 " used / " $2 " total"}'
  free -h | awk '/Swap:/{print "  Swap     : " $3 " used / " $2 " total"}'

  _section "Disk Usage"
  df -h | awk 'NR==1 || /^\// {printf "  %-20s %s / %s (%s)\n", $6, $3, $2, $5}'

  _section "Active Connections"
  ss -tuln | awk 'NR>1 {print "  " $1 "\t" $5}' | column -t

  _section "Top 5 Processes (CPU)"
  ps aux --sort=-%cpu | awk 'NR<=6 {printf "  %-20s %s%%\n", $11, $3}'

  _section "Last 10 System Logs"
  if _check_tool journalctl; then
    journalctl -n 10 --no-pager 2>/dev/null | awk '{print "  " $0}' || _warn "Cannot read logs"
  else
    tail -10 /var/log/syslog 2>/dev/null | awk '{print "  " $0}' || _warn "Cannot read syslog"
  fi

  _section "Failed Login Attempts"
  if [ -r /var/log/auth.log ]; then
    COUNT=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null || echo 0)
    if [ "$COUNT" -gt 0 ]; then
      _warn "$COUNT failed login attempts detected"
      grep "Failed password" /var/log/auth.log | tail -5 | awk '{print "  " $0}'
    else
      _ok "No failed logins"
    fi
  else
    _warn "Cannot read auth.log"
  fi

  _ok "Monitor complete."
}
