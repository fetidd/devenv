#!/usr/bin/env bash
# Add/remove cargo-installed tools below and re-run `chezmoi apply` to
# pick up the change. Uses cargo-binstall (prebuilt binaries) instead of
# `cargo install` for speed.
set -euo pipefail
# shellcheck source=/dev/null
source "$HOME/.cargo/env"

if ! command -v cargo-binstall >/dev/null 2>&1; then
  echo "==> Installing cargo-binstall"
  curl -L --proto '=https' --tlsv1.2 -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
fi

CARGO_TOOLS=(
  broot
  zellij
  gitui
  just
  cargo-nextest
  cross
  cargo-crap
)

echo "==> Installing cargo tools: ${CARGO_TOOLS[*]}"
cargo binstall -y "${CARGO_TOOLS[@]}"

echo "==> Running 'broot --install' to generate shell launcher + default skins"
"$HOME/.cargo/bin/broot" --install || true
