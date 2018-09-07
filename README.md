# tmux-yank_pwd

A tmux plugin for copying the current pane working directory to the system clipboard.


## Installation with TPM

1.  Add
    ```
    set -g @plugin 'IngoHeimbach/tmux-yank_pwd'
    ```
    to your `.tmux.conf`.

2.  Restart `tmux` or reload `.tmux.conf` and press `<prefix>-I`.


## Usage

Press `<prefix>-Y` to yank the working directory of your current pane to the system clipboard.


## Configuration

-   Set another yank key:
    ```
    set -g @yank_pwd_key "<your key>"
    ```
    Specify a custom key without tmux prefix (the default value for this option is `Y`).

-   Set a custom clip tool:

    `tmux-yank_pwd` tries to guess the correct clipboard copy command for your system. You can set a tool explicitly
    with:
    ```
    set -g @yank_pwd_clip_tool "<your clipboard tool>"
    ```
    The clipboard tool must read its input from stdin.
