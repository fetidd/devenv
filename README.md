# devenv

Reproducible dev setup for Fedora, managed with [chezmoi](https://chezmoi.io).

Covers: helix (`hx`), zellij, broot, git + gitui, docker, podman, rustup + cargo tools,
uv, starship, mise, and the supporting dnf packages (ripgrep, bat, fzf, fd, eza, direnv, gh, tmux).

## New machine

```
curl -fsSL https://raw.githubusercontent.com/fetidd/devenv/master/install.sh | bash
```

Installs `git` + `chezmoi`, then `chezmoi init --apply` pulls this repo and runs the
bootstrap scripts in `home/.chezmoiscripts/` (dnf packages, Docker CE repo + install,
rustup, cargo-binstall + cargo tools, starship, mise) before laying down the dotfiles.
Will prompt for your sudo password.

## Day-to-day maintenance

Run from `~/.local/share/chezmoi` (the chezmoi source dir this repo lives in):

| Command | What it does |
|---|---|
| `just add ~/.config/helix/config.toml` | Pull a live edit into the repo |
| `just diff` | Preview what `apply` would change |
| `just apply` | Apply source → `$HOME`; reruns any bootstrap script whose contents changed |
| `just edit ~/.bashrc` | Edit the source copy in `$EDITOR`, applies on save |
| `just push "message"` | Commit + push |
| `just update` | On another machine: pull latest from the remote and apply |

## Adding a new tool

Add its package name to the relevant array in `home/.chezmoiscripts/run_onchange_before_*.sh`:

- `00-dnf-and-docker.sh` — anything in Fedora's repos
- `02-cargo-tools.sh` — Rust-ecosystem CLI tools (installed via `cargo-binstall`)

Then `just apply` — installs it immediately here, and it's captured for the next
fresh machine. `run_onchange_` scripts rerun automatically whenever their contents
change, so no separate "bump a version" step is needed.

## Notes

- Rust toolchains stay on `rustup`, Python stays on `uv`. `mise` is there for any
  other language runtimes you pin later (node, go, ...) — kept separate to avoid the
  three tools fighting over the same job.
- broot's `skins/` and `launcher/` directories aren't tracked — they're boilerplate
  that `broot --install` regenerates (run automatically by `02-cargo-tools.sh`).
- gitui has no tracked config; it runs on defaults.
