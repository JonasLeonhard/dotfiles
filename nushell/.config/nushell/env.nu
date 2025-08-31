$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.keybindings = [
{
    name: clear_screen
    modifier: control
    keycode: char_h
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: executehostcommand,
        cmd: "clear"
    }
},
{
    name: accept_history_hint_completion
    modifier: control
    keycode: char_l
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: HistoryHintComplete,
    }
},
{
    name: history_down
    modifier: control
    keycode: char_j
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: PreviousHistory,
    }
},
{
    name: history_down
    modifier: control
    keycode: char_k
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: NextHistory,
    }
}
]

$env.config.edit_mode = 'vi'
$env.config.cursor_shape = {
    vi_insert: line
    vi_normal: block
}
$env.PROMPT_INDICATOR_VI_INSERT = {|| "" } # we are using cursor shapes to indicate the mode
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "" } # we are using cursor shapes to indicate the mode
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

$env.STARSHIP_CONFIG = $"($env.HOME)/.config/starship/starship.toml"

$env.path ++= ["~/.cargo/bin"]
