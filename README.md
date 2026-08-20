# Ishan's dotfiles

Personal macOS and remote-shell configuration, with zsh as the primary shell
and Bash retained as a remote fallback.

Read [SETUP.md](SETUP.md) before applying anything to a machine. It defines the
incremental setup workflow, safety rules, machine profiles, and a prompt for a
setup agent.

Authored configuration is linked from this repository into `$HOME`, so editing
the live file updates the tracked file directly. Machine identity, credentials,
and other private values remain in ignored local files. There is no separate
copy or refresh step.

Repository layout:

- `shell/zsh/`: primary shell configuration
- `shell/bash/`: Bash fallback with optional work settings
- `shell/bash/third-party/`: external Bash code kept in this repository
- `git/`: shared Git settings and a private local example
- `terminal/`: Ghostty, tmux, and Readline settings
- `packages/`: package-manager settings and machine inventory notes
- `editors/vim/`: Vim settings and color themes
- `editors/vscode/`: VS Code-compatible settings and extension IDs
- `jobs/`: scheduled jobs for a workstation
- `macos/`: reviewed macOS preferences
- `scripts/`: safe linking and read-only health checks

The Mac profile links only `~/.zshrc`; Bash configuration remains in the
repository for Bash-only remote machines. Each shell entry file loads the other
files from its directory. Those internal files use clear names such as
`environment`, `aliases`, `functions`, and `prompt`. They are not hidden because
they are repository modules, not home dotfiles. Helper links such as
`~/.aliases` and `~/.functions` are not necessary.

Both shell directories keep machine-specific settings in an optional `work/`
directory. Remote machines use the shared zsh or Bash modules plus Git, tmux,
Vim, and input configuration. There is no second remote copy to keep
synchronized.
