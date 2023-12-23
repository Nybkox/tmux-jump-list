# Tmux Jump List Plugin

The Tmux Jump List plugin enhances session navigation in `tmux`, similar to the Ctrl+O/I functionality in Vim. It allows users to easily jump between previous and next sessions, edit jump history, and reset the cursor position within `tmux`.

## Installation

### Using Tmux Plugin Manager (tpm)

Add the Tmux Jump List plugin to your list of `tpm` plugins in `.tmux.conf`:

```bash
set -g @plugin 'Nybkox/tmux-jump-list'
```

Hit `prefix` + `I` inside a `tmux` session to fetch the plugin and source it.

## Usage

Once installed, the plugin automatically sets up keybindings for jumping between sessions and other functionalities, provided the default keybindings are not disabled in the configuration.

## Keybindings

- `prefix+o`: Jump to the previous session.
- `prefix+i`: Jump to the next session.
- `prefix+J`: Edit the jump history.
- `prefix+R`: Reset the cursor position in the current session.

These keybindings can be customized in the `.tmux.conf` file.

## Configuration

You can customize the plugin behavior by setting options in your `.tmux.conf` file:

Disable default keybindings:

```bash
set -g @tmux-jump-list-default-keybindings "false"
```

Set custom keybindings:

```bash
set -g @tmux-jump-list-jump-prev "your_custom_key"
set -g @tmux-jump-list-jump-next "your_custom_key"
set -g @tmux-jump-list-edit-history "your_custom_key"
set -g @tmux-jump-list-reset-cursor "your_custom_key"
```

## Known issues

You may need to manually give permission to plugin's scripts.

```bash
cd ~/.tmux/plugins/tmux-jump-list
chmod u+x tmux-jump-list-plugin.tmux
chmod u+x ./**/*.sh
```
