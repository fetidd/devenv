#!/usr/bin/env bash
# Reruns automatically whenever this file's contents change (chezmoi
# run_onchange_ semantics) - add/remove dnf packages below and re-run
# `chezmoi apply` to pick them up. All steps are idempotent.
set -euo pipefail

DNF_PACKAGES=(
  git
  helix
  ripgrep
  bat
  tmux
  podman
  direnv
  fd-find
  eza
  gh
  uv
  fzf
  python3-pip
)

echo "==> Installing dnf packages: ${DNF_PACKAGES[*]}"
sudo dnf install -y "${DNF_PACKAGES[@]}"

if ! rpm -q docker-ce >/dev/null 2>&1; then
  echo "==> Adding Docker CE repo"
  sudo dnf install -y dnf-plugins-core
  sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
  echo "==> Installing Docker CE"
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  if [ -d /run/systemd/system ]; then
    sudo systemctl enable --now docker
  else
    echo "==> No systemd (container/minimal env) - skipping 'systemctl enable --now docker'"
  fi
fi

CURRENT_USER="$(id -un)"
if ! id -nG "$CURRENT_USER" | grep -qw docker; then
  echo "==> Adding $CURRENT_USER to docker group (log out/in for it to take effect)"
  sudo usermod -aG docker "$CURRENT_USER"
fi
