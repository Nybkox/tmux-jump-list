#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"

push_to_history() {
	cursor=$(read_cursor)
	from_jump_flag=$(read_from_jump_flag)

	if [ "$from_jump_flag" -eq 1 ]; then
		set_from_jump_flag 0
		return
	fi

	# Truncate forward history if we navigated back (vim-style)
	if [ "$cursor" -gt 1 ]; then
		total_lines=$(read_history_length)
		lines_to_keep=$((total_lines - cursor + 1))
		if [ "$lines_to_keep" -gt 0 ]; then
			head -n "$lines_to_keep" "$HISTORY_FILE" >"$HISTORY_FILE.tmp"
			mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
		fi
	fi

	last_line=$(read_last_line)

	# Prevent duplicates in a row
	if [ "$last_line" = "$@" ]; then
		reset_cursor
		return
	fi

	total_lines=$(read_history_length)
	max_lines=$(get_tmux_option @tmux-jump-list-max-history 10)

	# Delete extra lines
	if [ "$total_lines" -ge "max_lines" ]; then
		start_line=$((total_lines - max_lines))
		sed -i '' "1,$((start_line - 1))d" "$HISTORY_FILE"
	fi

	echo "$@" >>"$HISTORY_FILE"
	reset_cursor
}

edit_history() {
	tmux display-popup -E "${EDITOR:-vim} $HISTORY_FILE"
}

jump_prev() {
	cursor=$(read_cursor)
	next_cursor=$((cursor + 1))
	total_lines=$(read_history_length)

	if [ "$next_cursor" -le $((total_lines)) ]; then
		line=$(read_line "$next_cursor")
		set_cursor "$next_cursor"
		set_from_jump_flag 1
		tmux switch-client -t "$line"
	fi
}

jump_next() {
	cursor=$(read_cursor)
	next_cursor=$((cursor - 1))
	total_lines=$(read_history_length)

	if [ "$next_cursor" -ge 1 ]; then
		line=$(read_line "$next_cursor")
		set_cursor "$next_cursor"
		set_from_jump_flag 1
		tmux switch-client -t "$line"
	fi
}

if [ "$1" = "edit_history" ]; then
	edit_history
elif [ "$1" = "push_to_history" ]; then
	shift
	push_to_history "$@"
elif [ "$1" = "jump_prev" ]; then
	jump_prev
elif [ "$1" = "jump_next" ]; then
	jump_next
elif [ "$1" = "reset_cursor" ]; then
	reset_cursor
else
	echo "Usage: $0 [edit_history|push_to_history|jump_prev|jump_next]; Recieved: $1"
	exit 1
fi
