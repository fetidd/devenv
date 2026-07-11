#!/usr/bin/env bash
# Bootstrap a brand new Fedora install from this dotfiles repo.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/fetidd/devenv/master/install.sh | bash
#
# This only installs git + chezmoi, then hands off to chezmoi, which
# applies dotfiles and runs the run_onchange_ scripts in .chezmoiscripts/
# (dnf packages, Docker, rustup, cargo tools, starship, mise).
set -euo pipefail

sudo dnf install -y git chezmoi

chezmoi init --apply fetidd/devenv
