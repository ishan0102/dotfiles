# Editor settings

`vim/` is active through the `~/.vimrc` and `~/.vim/colors` links.

`vscode/` contains settings that work with Cursor and VS Code. Cursor is the
active editor on this Mac. The tracked settings are a safe copy of the current
Cursor settings. Machine-specific paths and settings that bypass security
prompts are not included.

`extensions.txt` contains one extension ID per line. A setup agent must compare
this list with the target editor before it installs or removes an extension.

Do not replace editor files while the editor is open. Back up the current user
files, compare them with this directory, and apply one file at a time.
