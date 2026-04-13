# sectool

![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux-FCC624?logo=linux&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-blue)
![Status](https://img.shields.io/badge/Status-WIP-orange)

> CLI Bash qui orchestre nmap, lynis, rkhunter, fail2ban et ufw dans une interface unifiée pour auditer, durcir et surveiller un système Linux.

## Installation

git clone git@github.com:sawadogo749/sectool.git
cd sectool
chmod +x sectool.sh modules/*.sh
./sectool.sh

## Modules

- Audit — ports ouverts, logins, SUID
- Hardening — firewall, SSH, kernel
- Report — rapport complet horodaté
- Monitor — surveillance live (bientôt)
