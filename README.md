# Chezmoi dotfiles

## Initial config

Create the ~/.config/chezmoi/chezmoi.toml, like the following:
```
encryption = "gpg"
[data]
    email = "<real@address>"
[diff]
    command = "delta"
    args = ["--paging", "never", "{{ .Destination }}", "{{ .Target }}"]
[gpg]
    args = ["--batch", "--passphrase", "<passphrase>", "--no-symkey-cache", "--quiet"]
    symmetric = true
[merge]
    command = "nvim"
    args = ["-d", "{{ .Destination }}", "{{ .Source }}", "{{ .Target }}"]
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

* Install: `chezmoi init --apply git@github.com:dperson/dotfiles.git`
* See what would change: `chezmoi diff`
* Add encrypted files: `chezmoi add --encrypt`
* Apply changes: `chezmoi apply -v`
* Edit: `chezmoi edit $FILE`
* Merge changes: `chezmoi merge $FILE`
* Goto chezmoi dir: `chezmoi cd`
* Run **git** command on chezmoi repo: `chezmoi git -- $CMD`

## Setup
```
chezmoi init git@github.com:dperson/dotfiles.git
chezmoi add --encrypt .cert .gnupg .netrc .ssh
chezmoi add .abcde.conf .bash_logout .bashrc .config/nvim/lua/custom \
      .config/ohmyzsh/p10k.zsh .config/tmux .config/starship.toml .exrc \
      .inputrc .local/bin .mozilla/saved .mozilla/user* .muttrc .profile* \
      .zlogout .zprofile .zshrc
chezmoi add --template .gitconfig
chezmoi edit .gitconfig # {{ .email | quote }}
chezmoi git -- branch -M main
chezmoi git -- add .
chezmoi git -- commit -m "first commit"
chezmoi git -- remote add origin git@github.com:dperson/dotfiles.git
chezmoi git -- push -ff -u origin main
```