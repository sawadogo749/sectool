#!/usr/bin/env bash

_section() { echo -e "\n${BOLD}${BLUE}== $1 ==${RESET}"; }
_ok()      { echo -e "  ${GREEN}OK${RESET} $1"; }
_warn()    { echo -e "  ${YELLOW}!!${RESET} $1"; }
_check_tool() { command -v "$1" &>/dev/null; }

run_hardening() {
  echo -e "\n${CYAN}[*] Running hardening checks...${RESET}\n"

  _section "Firewall (ufw)"
  if _check_tool ufw; then
    STATUS=$(sudo ufw status 2>/dev/null | head -1)
    echo "$STATUS" | grep -q "active" && _ok "ufw is active" || _warn "ufw is inactive"
  else
    _warn "ufw not installed — sudo apt install ufw"
  fi

  _section "Fail2ban"
  if _check_tool fail2ban-client; then
    _ok "fail2ban is installed"
  else
    _warn "fail2ban not installed — sudo apt install fail2ban"
  fi

  _section "SSH config"
  SSHD="/etc/ssh/sshd_config"
  if [ -r "$SSHD" ]; then
    grep -q "^PermitRootLogin no" "$SSHD" && _ok "PermitRootLogin = no" || _warn "PermitRootLogin should be no"
    grep -q "^PasswordAuthentication no" "$SSHD" && _ok "PasswordAuthentication = no" || _warn "Consider disabling password auth"
  else
    _warn "Cannot read $SSHD"
  fi

  _section "Kernel (sysctl)"
  for key in net.ipv4.ip_forward net.ipv4.conf.all.accept_redirects kernel.randomize_va_space; do
    val=$(sysctl -n "$key" 2>/dev/null)
    _ok "$key = $val"
  done

  _ok "Hardening complete."
  export HARDENING_DONE=1
}
