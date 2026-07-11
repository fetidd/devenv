#!/usr/bin/env bash
# Not packaged in Fedora repos, so installed via their official scripts.
# Note: Rust toolchains stay on rustup and Python stays on uv - mise is
# here for any *other* language runtimes you pin later (node, go, ...).
set -euo pipefail

if ! command -v starship >/dev/null 2>&1; then
  echo "==> Installing starship"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

if ! command -v mise >/dev/null 2>&1; then
  echo "==> Installing mise"
  curl https://mise.run | sh
fi
