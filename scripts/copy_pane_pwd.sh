#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}"

source "${SCRIPTS_DIR}/helpers.sh"

yank_pwd_clip_tool_default="auto"
yank_pwd_clip_tool_option="@yank_pwd_clip_tool"

yank_pwd_clip_tool() {
    get_tmux_option "${yank_pwd_clip_tool_option}" "${yank_pwd_clip_tool_default}"
}

guess_clipboard_copy_command() {
    if command -v "pbcopy" >/dev/null 2>&1; then
        if command -v "reattach-to-user-namespace" >/dev/null 2>&1; then
            echo "reattach-to-user-namespace pbcopy"
        else
            echo "pbcopy"
        fi
    elif command -v "clip.exe" >/dev/null 2>&1; then # WSL clipboard command
        echo "clip.exe"
    elif command -v "xsel" >/dev/null 2>&1; then
        local xsel_selection
        xsel_selection="$(yank_selection)"
        echo "xsel -i --$xsel_selection"
    elif command -v "xclip" >/dev/null 2>&1; then
        local xclip_selection
        xclip_selection="$(yank_selection)"
        echo "xclip -selection $xclip_selection"
    elif command -v "putclip" >/dev/null 2>&1; then # cygwin clipboard command
        echo "putclip"
    else
        echo "" # no clipboard command found
    fi
}

tmux_copy_command() {
    echo "tmux load-buffer -"
}

pane_current_path() {
    tmux display -p -F "#{pane_current_path}"
}

display_notice() {
    display_message 'PWD copied to tmux paste buffer and clipboard!'
}

display_error() {
    display_message 'ERROR: No clipboard command found!'
}

main() {
    local clipboard_copy_command tmux_copy_command pane_current_path_without_newline

    clipboard_copy_command="$(yank_pwd_clip_tool)"
    if [[ "${clipboard_copy_command}" == "auto" ]]; then
        clipboard_copy_command="$(guess_clipboard_copy_command)"
        if [[ -z "${clipboard_copy_command}" ]]; then
            display_error
            return 1
        fi
    fi
    tmux_copy_command="$(tmux_copy_command)"

    # The copy command variables should not be quoted
    pane_current_path_without_newline="$(pane_current_path | tr -d '\n')" && \
    echo -n "${pane_current_path_without_newline}" | ${clipboard_copy_command} && \
    echo -n "${pane_current_path_without_newline}" | ${tmux_copy_command} && \
    display_notice
}

main
