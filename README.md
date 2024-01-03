# Chezmoi dotfiles

## Initial config

Create the `~/.config/chezmoi/chezmoi.toml`, like the following:
```
encryption = "gpg"
progress = true
[data]
  email = "<real@address>"
[diff]
  command = "delta"
  args = ["--paging", "never", "{{ .Destination }}", "{{ .Target }}"]
  scriptContents = false
[gpg]
  args = ["--batch", "--passphrase", "<passphrase>",
        "--no-symkey-cache", "--quiet"]
  symmetric = true
[merge]
  command = "nvim"
  args = ["-d", "{{ .Destination }}", "{{ .Source }}", "{{ .Target }}"]
[status]
  exclude = ["scripts"]
```

## Preinstall
* chezmoi
* fzf
* git
* git-delta (delta)
* gpg
* neovim / NvChad
* ohmyzsh
* ripgrep
* tmux / TPM (this could come after)

## Commands

* Install: `chezmoi init --ssh --verbose dperson`
* See what would change: `chezmoi diff`
* Add encrypted files: `chezmoi add --encrypt`
* Apply changes: `chezmoi apply -v`
* Edit: `chezmoi edit $FILE`
* Merge changes: `chezmoi merge $FILE`
* Goto chezmoi dir: `chezmoi cd`
* Run **git** command on chezmoi repo: `chezmoi git -- $CMD`
* Reset run once scripts: `chezmoi state delete-bucket --bucket=scriptState`

## Setup
```
chezmoi init --ssh --verbose dperson
chezmoi add --encrypt .cert .gnupg .netrc .ssh
chezmoi add .abcde.conf .bash_logout .bashrc .config/Brewfile .config/kitty \
      .config/niri .config/nvim/.gitignore .config/nvim/.stylua.toml \
      .config/nvim/init.lua .config/nvim/lua .config/ohmyzsh/p10k.zsh \
      .config/starship.toml .config/tmux/tmux-screen-keys.conf \
      .config/tmux/tmux.conf .config/waybar .config/wezterm .exrc .gitconfig \
      .inputrc .justfile .local/bin .local/share/org.gnome.Ptyxis \
      .local/share/virtualenvs/ansible.sh .local/share/virtualenvs/pmb.sh \
      .mozilla/saved .mozilla/user* .muttrc .profile* .zlogout .zprofile .zshrc
chezmoi add --template .gitconfig
chezmoi edit .gitconfig # {{ .email | quote }}
chezmoi git -- branch -M main
chezmoi git -- add .
chezmoi git -- commit -m "first commit"
chezmoi git -- remote add origin git@github.com:dperson/dotfiles.git
chezmoi git -- push -ff -u origin main
```