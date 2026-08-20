# Package and runtime state

Audit date: 2026-08-20.

The root `Brewfile` is the reviewed base manifest for a personal Mac. It lists
only tools used by the tracked setup. Homebrew installs their dependencies.

The text files in this directory are dated audits of the current Mac. They are
not automatic install lists. A setup agent must use them to ask which work,
language, media, and personal applications are still necessary.

`Brewfile.work` is an optional reviewed list for the current work projects. It
must not run on a personal or remote machine.

## Required by this setup

The current configuration uses these tools when they are available:

- `git`, `gh`, and `git-delta`
- `zsh` and the macOS Bash fallback
- `fzf` for Ctrl-R history search
- `z` for directory history
- `coreutils` for precise Bash command timing
- `bat`, `ripgrep`, `fd`, `jq`, `tmux`, and `shellcheck`
- `uv` for the two scheduled jobs
- Ghostty for the tracked terminal settings

The remote profile must use a smaller list. It does not need GUI applications,
work databases, cloud tools, or scheduled jobs.

## Current runtime state

- Python commands: 3.10, 3.11, 3.13, and 3.14
- Node commands: 22 and 25
- Bun: 1.2
- Go: 1.25
- Swift: 6.3
- Java: 11
- Rust 1.92 is installed but cannot start because its LLVM library is not
  compatible with the installed LLVM version.

## Clear package review items

- Remove `neofetch` from the next manifest. `fastfetch` replaces it.
- Remove `openssl@1.1` and `python@3.8` from the next manifest. Homebrew has
  disabled them.
- The base manifest replaces the disabled `tldr` formula with `tlrc`.
- Review whether both Node versions and all four Python versions are necessary.
- Review old explicit tools such as Emacs, irssi, sbt, Subversion, R, and Yarn.
- Repair Rust and LLVM only in a separate package-maintenance step.

Homebrew directory ownership is correct on this Mac. Writability warnings from
the audit were caused by the restricted audit environment. Do not run a broad
`chown` command based on those warnings.
