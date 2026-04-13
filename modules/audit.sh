#!/usr/bin/env bash

_section() { echo -e "\n${BOLD}${BLUE}== $1 ==${RESET}"; }
_ok()      { echo -e "  ${GREEN}OK${RESET} $1"; }
_warn()    { echo -e "  ${YELLOW}!!${RESET} $1"; }
_check_tool() { command -v "$1" &>/dev/null; }

run_audit() {
  echo -e "\n${CYAN}[*] Starting audit...${RESET}\n"

  _section "Open Ports"
  ss -tuln | awk 'NR>1 {print "  " $1 "\t" $5}' | column -t

  _section "Nmap scan"
  if _check_tool nmap; then
    nmap -sV --open -T4 localhost 2>/dev/null | grep -E "^[0-9]+|open" || _warn "Nothing found"
  else
    _warn "nmap not installed — sudo apt install nmap"
  fi

  _section "Failed logins"
  if [ -r /var/log/auth.log ]; then
    grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5 || _ok "None found"
  else
    _warn "Cannot read auth.log"
  fi

  _section "SUID binaries"
  find / -perm -4000 -type f 2>/dev/null | head -10 | while read -r f; do
    _warn "$f"
  done

  _ok "Audit complete."
  export AUDIT_DONE=1
  export AUDIT_TIMESTAMP
  AUDIT_TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
}
