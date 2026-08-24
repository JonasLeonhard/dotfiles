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
    name: history_prev
    modifier: control
    keycode: char_j
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: PreviousHistory,
    }
},
{
    name: history_next
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

$env.path ++= [
    "~/.cargo/bin",
    "~/.local/share/nvim/mason/bin"
]

$env.PROMPT_COMMAND_RIGHT = {|| "" }
$env.PROMPT_COMMAND = {||
    const green = "#a6e3a1"
    const red = "#f38ba8"
    const blue = "#89b4fa"
    const peach = "#fab387"
    const yellow = "#f9e2af"
    const flamingo = "#f2cdcd"
    const black = "#000000"

    # Git fetch
    let result = (do -i { git branch --show-current } | complete)
    let git_info = if $result.exit_code != 0 {
        { is_git: false, branch: "" }
    } else {
        let branch = ($result.stdout | str trim)
        if ($branch | is-empty) {
            { is_git: true, branch: "detached" }
        } else {
            { is_git: true, branch: $branch }
        }
    }

    let colors = [$blue, $peach, $yellow, $flamingo]
    mut color_idx = 0

    let last_exit = if ($env.LAST_EXIT_CODE? | default 0) == 0 { $green } else { $red }
    let char_part = $"(ansi {fg: $last_exit})(ansi {fg: $black, bg: $last_exit}) "

    mut prev_bg = $last_exit # for transitioning colors

    # Directory
    let dir_color = $colors | get $color_idx
    $color_idx += 1
    let dir = ($env.PWD | str replace $env.HOME "~")
    let dir_part = $"(ansi {fg: $prev_bg, bg: $dir_color})(ansi {fg: $black, bg: $dir_color}) ($dir) "
    $prev_bg = $dir_color

    # Git
    let git_part = if $git_info.is_git {
        let current_color = $colors | get $color_idx
        $color_idx += 1
        let trans = $"(ansi {fg: $prev_bg, bg: $current_color})(ansi {fg: $black, bg: $current_color})  ($git_info.branch) "
        $prev_bg = $current_color
        $trans
    } else {
        ""
    }

    # Duration
    let duration_ms = ($env.CMD_DURATION_MS? | default "0" | into duration --unit ms)
    let duration_part = if $duration_ms > 500ms {
        let current_color = $colors | get $color_idx
        $color_idx += 1
        let trans = $"(ansi {fg: $prev_bg, bg: $current_color})(ansi {fg: $black, bg: $current_color}) 󰔟 (($duration_ms)) "
        $prev_bg = $current_color
        $trans
    } else {
        ""
    }

    let end_part = $"(ansi reset)(ansi {fg: $prev_bg})(ansi reset) "

    $"\n($char_part)($dir_part)($git_part)($duration_part)($end_part)"
}
