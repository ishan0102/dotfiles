# Machine setup

This repository is the source of truth for Ishan's interactive shell and
developer-machine preferences. Setup is intentionally incremental: inspect the
machine first, apply one coherent change at a time, validate it, and keep every
step easy to reverse.

The repository uses zsh as its primary shell and keeps authored configuration
shared rather than maintaining copied machine snapshots. The root `Brewfile`
contains the reviewed base tools for a personal Mac. Package files under
`packages/` are audit records and are not automatic install lists.

## Profiles

### `mac`

Use for a personal macOS workstation.

- Prefer zsh as the interactive and login shell.
- Include Homebrew packages, GUI applications, editor configuration, and
  explicitly reviewed macOS preferences.
- Keep machine identity, authentication, work credentials, and other secrets in
  ignored local files or a password manager.
- Treat privacy permissions, FileVault, Touch ID, iCloud, display arrangement,
  and licensed applications as manual steps unless a safe supported mechanism
  exists.

### `remote`

Use for Linux servers, development boxes, and temporary SSH hosts.

- Detect the operating system, distribution, package manager, architecture,
  available privileges, and current shell before proposing changes.
- Install only terminal-oriented configuration and a deliberately small tool
  set. Do not install macOS settings, GUI applications, personal cron jobs, or
  workstation-specific paths.
- Do not assume Homebrew, `sudo`, systemd, a persistent home directory, or the
  ability to change the login shell.
- Prefer a user-local zsh setup when system-level installation or `chsh` is not
  appropriate.
- Reuse `shell/zsh/`, Git, tmux, Vim, and input configuration.
  There is intentionally no duplicated `remote/` tree.
- If zsh cannot be installed, keep Bash as a minimal fallback and exclude
  workstation-only aliases, paths, jobs, and application settings.
- Never copy credentials from another machine. Authenticate the remote machine
  independently and only when the task requires it.

After the read-only audit, apply and check the remote profile from the repository
root:

```sh
./scripts/link.sh remote
./scripts/doctor.sh remote
```

Both zsh and Bash select the `remote` profile automatically on systems other
than macOS, and the optional `work` modules default to off. The remote link
profile skips `.hushlogin` and Ghostty. The setup process also skips macOS
settings, GUI applications, and scheduled jobs. The shared shell files stay in
one place, so fixes do not drift between workstation and remote copies.

## Safety contract

An agent or person working from this repository should:

1. Start with read-only inspection and report the detected profile and any
   conflicts.
2. Preserve existing files before replacing them. Never silently overwrite a
   non-symlinked user configuration.
3. Show the exact intended change before operations that require `sudo`, change
   the login shell, install background services, or alter security settings.
4. Keep authored configuration in the repository and machine-private values in
   ignored local files.
5. Use small, idempotent helper scripts only for deterministic mechanics such as
   validation and linking. Keep discovery and machine-specific judgment in this
   runbook and the agent's plan.
6. Validate login and non-login shells separately. A failed new shell must not
   remove the working shell configuration.
7. Make coherent local milestone commits as changes are completed. Never push
   unless Ishan explicitly asks.

After the read-only audit, use `scripts/link.sh` only if every reported target
is safe to link. The script stops before it replaces an existing file. Run
`scripts/doctor.sh` after each setup stage.

## Private local settings

Copy the local example for your shell to your home directory. Use the local
file to select the machine profile and work settings. Git ignores the real
file. Only its owner must be able to read it.

The shell detects `mac` on macOS and `remote` on other systems. The local file
normally needs only `DOTFILES_LOAD_WORK=1` on a work Mac. Keep it at `0` on a
personal or remote machine. Override `DOTFILES_PROFILE` only when the detected
profile is wrong.

```sh
cp shell/zsh/.zshrc.local.example ~/.zshrc.local
chmod 600 ~/.zshrc.local
```

For the Bash fallback, use:

```sh
cp shell/bash/.bashrc.local.example ~/.bashrc.local
chmod 600 ~/.bashrc.local
```

Git identity is also local to each machine:

```sh
cp git/.gitconfig.local.example ~/.gitconfig.local
chmod 600 ~/.gitconfig.local
```

Replace the example identity before the first commit. Configure commit signing
only after the signing key is available on the machine. Run `gh auth setup-git`
after GitHub CLI authentication.

Private values may temporarily live in `~/.extras`, also with mode `0600`, but
new machines should retrieve secrets from a password manager instead of copying
that file. Credential directories should use mode `0700`, and credential files
inside them should use mode `0600`.

## Shell history

zsh keeps native local history at `~/.local/state/zsh/history`, and fzf provides
the interactive Ctrl-R search interface. History is private machine state;
never link or commit it to this repository.

Before a history migration, back up `~/.bash_history` and the native zsh
history. Merge Bash history only once per source snapshot, keeping older Bash
entries before newer zsh entries so Up-arrow and Ctrl-R prioritize recent
commands.

## Scheduled jobs

The `jobs/` directory contains independent macOS cron runners. Each runner sets
its own minimal `PATH`, changes to its project directory, and writes the latest
run to `~/.cron`. Install the tracked schedule only after confirming both project
directories and their private environment files exist:

```sh
crontab jobs/crontab
```

These jobs are workstation-specific and should be skipped for the `remote`
profile.

## macOS preferences

Read `macos/README.md` and compare the target Mac with
`macos/preferences.sh`. The file is an opt-in list. Do not apply it without a
review. Complete the manual checks in the README separately.

## Editor settings

Read `editors/README.md`. Preserve the active editor files before you apply the
tracked settings. Install only the extension IDs that are valid for the target
editor.

## Prompt for a setup agent

Use this as the starting prompt on a new machine:

> Help me configure this machine using my dotfiles repository. Read `SETUP.md`
> and the repository README completely before making changes. First perform a
> read-only audit and determine whether this machine is a `mac` workstation or a
> `remote` host. Report what is already installed, what conflicts with the
> repository, what would require elevated privileges, and a small staged plan.
> Preserve existing configuration, never copy or commit secrets, and do not
> push Git changes. Apply and validate one reversible stage at a time. Prefer
> zsh, but do not change the login shell until the new configuration has passed
> isolated and interactive tests.

For a remote machine, append:

> Use the `remote` profile. Keep the install minimal and terminal-only. Do not
> assume Homebrew, macOS, `sudo`, systemd, or a permanent host. Reuse the shared
> zsh, Git, tmux, Vim, and input configuration; there is no separate remote
> copy. If zsh is unavailable, install only a minimal Bash fallback. Skip
> unsupported pieces and all workstation-specific jobs, aliases, and paths.

## Remaining migration work

The shell migration, shared configuration, editor inventory, macOS preference
record, scheduled-job split, linking helper, and doctor are complete. Remaining
work should use a small number of milestone commits:

1. Decide which optional tools from the package audit need another manifest.
2. Repair or remove the package-health items in `packages/README.md`.

The Mac and remote link profiles have passed fresh temporary-home simulations.
Both shell profiles also passed syntax checks and interactive startup checks.
