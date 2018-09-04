#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${CURRENT_DIR}/scripts"

source "${SCRIPTS_DIR}/helpers.sh"

yank_pwd_key_default="Y"
yank_pwd_key_option="@yank_pwd_key"

yank_pwd_key() {
    get_tmux_option "${yank_pwd_key_option}" "${yank_pwd_key_default}"
}

setup_bindings() {
    tmux bind-key "$(yank_pwd_key)" run-shell -b "${SCRIPTS_DIR}/copy_pane_pwd.sh"
}

main() {
    setup_bindings
}

main
