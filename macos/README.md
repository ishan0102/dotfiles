# macOS state

The preferences in `preferences.sh` were read from this Mac on 2026-08-20.
The machine used macOS 26.6 on Apple silicon.

The file contains only settings that are useful on another Mac. It does not
contain account data, device IDs, application state, or security permissions.
Review the file before you run it:

```sh
sh macos/preferences.sh
```

Do not run the file on a remote machine.

## Manual checks

An agent must report these items but must not change them without approval:

- FileVault and recovery-key storage
- Touch ID and Apple Watch authentication
- iCloud services and storage settings
- Privacy permissions for the terminal, editor, browser, and screen tools
- Login items and background services
- Display scale, arrangement, color profile, and refresh rate
- Keyboard layout, shortcuts, and input sources
- Sound input, sound output, and alert volume
- Wallpaper, focus modes, and notification rules
- Time Machine or another backup system
- Application licenses and accounts
