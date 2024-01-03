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
* oh-my-posh
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