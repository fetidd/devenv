# devenv

Reproducible Fedora dev setup, managed with chezmoi + a Justfile. See `README.md` for
day-to-day usage commands (`just add`, `just diff`, `just apply`, `just push`, `just update`).

## Layout

`.chezmoiroot` points the real chezmoi source root at `home/` — repo-root files
(`Justfile`, `install.sh`, `README.md`, this file) are tooling and are never applied
to `$HOME`. Only stuff under `home/` becomes a dotfile.

## Conventions to preserve when editing

- **Package installs are plain bash arrays** in `home/.chezmoiscripts/run_onchange_before_NN-*.sh`,
  not a data file + parser. Don't introduce a packages.toml/yaml — a fresh machine may
  not have a parser available yet, and the array is the whole point: edit it, `just apply`,
  done. `run_onchange_` reruns automatically whenever the script's content changes.
- **Tool boundaries are deliberate**: Rust stays on rustup, Python stays on uv. `mise`
  is reserved for other future language runtimes only — don't route Rust/Python through
  it, that would make two tools fight over the same job.
- **Rust-ecosystem CLI tools go through `cargo-binstall`** (`00-dnf-and-docker.sh` vs
  `02-cargo-tools.sh` split), not dnf, even for tools dnf also has (e.g. gitui, just).
  This matches how the user actually has these installed today — keep it that way
  rather than "simplifying" to dnf.
- **broot's `skins/` and `launcher/` dirs are not tracked** — they're boilerplate that
  `broot --install` regenerates (run automatically at the end of `02-cargo-tools.sh`).
  Only `conf.hjson`/`verbs.hjson` are real user config.
- **gitui has no tracked config** — it runs on defaults; don't invent one.
- Docker is installed from Docker CE's official repo, not Fedora's `moby-engine`; the
  user is added to the `docker` group as part of setup.

## Adding a new tool

Add the package name to the relevant array (`00-dnf-and-docker.sh` for anything in
Fedora's repos, `02-cargo-tools.sh` for Rust-ecosystem CLIs), then `just apply`.
