#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HISTORY_FILE="$CURRENT_DIR/.tmux-jump-history"
CURSOR_FILE="$CURRENT_DIR/.tmux-jump-cursor"
FROM_JUMP_FLAG_FILE="$CURRENT_DIR/.tmux-from-jump-flag"

if [ ! -f "$HISTORY_FILE" ]; then
	touch "$HISTORY_FILE"
fi

if [ ! -f "$CURSOR_FILE" ]; then
	touch "$CURSOR_FILE"
	echo "1" >"$CURSOR_FILE"
fi

if [ ! -f "$FROM_JUMP_FLAG_FILE" ]; then
	touch "$FROM_JUMP_FLAG_FILE"
	echo "0" >"$FROM_JUMP_FLAG_FILE"
fi

set_cursor() {
	echo "$1" >$CURSOR_FILE
}

reset_cursor() {
	echo "1" >"$CURSOR_FILE"
}

read_cursor() {
	if read -r line <"$CURSOR_FILE"; then
		if [[ "$line" =~ ^-?[0-9]+$ ]]; then
			echo "$line"
			return
		fi
	fi

	reset_cursor
	echo "0"
}

set_from_jump_flag() {
	echo "$1" >$FROM_JUMP_FLAG_FILE
}

read_from_jump_flag() {
	if read -r line <"$FROM_JUMP_FLAG_FILE"; then
		if [[ "$line" =~ ^-?[0-9]+$ ]]; then
			echo "$line"
			return
		fi
	fi

	set_from_jump_flag 0
	echo "0"
}

read_history_length() {
	echo $(wc -l <"$HISTORY_FILE")
}

read_last_line() {
	echo $(tail -n 1 "$HISTORY_FILE")
}

read_line() {
	echo $(tail -n "$1" "$HISTORY_FILE" | head -n 1)
}
