# shellcheck shell=bash

# Back up personal Mac data to the configured development host.
backupmac() {
    if [ -z "${DEVBOX_IP:-}" ]; then
        printf '%s\n' 'backupmac: DEVBOX_IP is not configured' >&2
        return 1
    fi

    rsync \
        -avz \
        --info=progress2 \
        --stats \
        --exclude=.git/ \
        --exclude=venv/ \
        --exclude=.venv/ \
        --exclude=.next/ \
        --exclude=__pycache__/ \
        --exclude=node_modules/ \
        "$HOME/Documents/" \
        "$HOME/happenstance" \
        "$DEVBOX_IP:~/documents/mac-backup"
}
