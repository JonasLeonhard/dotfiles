# zoxide init nushell | save -f ~/.cache/zoxide/init.nu
source ~/.cache/zoxide/init.nu

# Aliases (must be after sources!)
alias rcd = cd
alias cdi = zi
alias cat = bat
alias cd = z

# adds xterm-256color to ssh sessions, because using wezterm as TERM on a remote system caused issues
def --wrapped ssh [...args] {
    with-env { TERM: "xterm-256color" } {
        ^ssh ...$args
    }
}
