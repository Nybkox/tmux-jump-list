#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_FILE="$CURRENT_DIR/commands.sh"

source "$CURRENT_DIR/utils.sh"

main() {
	if [ ! -f "$COMMANDS_FILE" ]; then
		echo "Error: jump-list.sh not found at $COMMANDS_FILE"
		exit 1
	fi

	tmux set-environment -g COMMANDS_FILE "$COMMANDS_FILE"

	tmux set-hook -g client-session-changed 'run-shell "#{COMMANDS_FILE} push_to_history #{session_name}"'

	if [ $(get_tmux_option @tmux-jump-list-default-keybindings true) = "true" ]; then
		tmux unbind-key o
		tmux unbind-key i
		tmux unbind-key J
		tmux unbind-key R

		tmux bind-key -r o run-shell "#{COMMANDS_FILE} jump_prev"
		tmux bind-key -r i run-shell "#{COMMANDS_FILE} jump_next"
		tmux bind-key -r J run-shell "#{COMMANDS_FILE} edit_history"
		tmux bind-key -r R run-shell "#{COMMANDS_FILE} reset_cursor"
	fi

	bind_if_set @tmux-jump-list-jump-prev 'run-shell "#{COMMANDS_FILE} jump_prev"'
	bind_if_set @tmux-jump-list-jump-next 'run-shell "#{COMMANDS_FILE} jump_next"'
	bind_if_set @tmux-jump-list-edit-history 'run-shell "#{COMMANDS_FILE} edit_history"'
	bind_if_set @tmux-jump-list-reset-cursor 'run-shell "#{COMMANDS_FILE} reset_cursor"'
}

main
