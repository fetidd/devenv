# Dotfiles maintenance. Run `just` from ~/.local/share/chezmoi (the
# chezmoi source dir) or anywhere with `just --justfile ~/.local/share/chezmoi/Justfile`.

default:
    @just --list

# Preview what `chezmoi apply` would change
diff:
    chezmoi diff

# Apply the current source state to $HOME (runs any changed run_onchange_ scripts)
apply:
    chezmoi apply -v

# Pull a live config file (e.g. ~/.config/helix/config.toml) into the source dir
add FILE:
    chezmoi add {{ FILE }}

# Edit a managed file's source copy in $EDITOR and apply on save
edit FILE:
    chezmoi edit --apply {{ FILE }}

# Pull latest source from the remote and apply - run this on any machine to sync
update:
    chezmoi update -v

# Commit and push local source changes to the remote
push MESSAGE:
    chezmoi git -- add -A
    chezmoi git -- commit -m "{{ MESSAGE }}"
    chezmoi git -- push
