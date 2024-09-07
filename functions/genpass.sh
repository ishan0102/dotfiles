#!/bin/bash

genpass() {
    local wordlist_file="${HOME}/.functions/data/wordlist.txt"
    local num_words=${1:-4}
    local separator=${2:--}
    local passphrase=""

    # Check if wordlist file exists
    if [ ! -f "$wordlist_file" ]; then
        echo "Error: Wordlist file not found at $wordlist_file" >&2
        return 1
    fi

    # Read words from file into an array
    IFS=$'\n' read -d '' -r -a words < "$wordlist_file"

    # Generate passphrase
    for ((i=1; i<=num_words; i++)); do
        random_index=$((RANDOM % ${#words[@]}))
        passphrase+="${words[random_index]}"
        if [ $i -lt $num_words ]; then
            passphrase+="$separator"
        fi
    done

    # Copy to clipboard and print confirmation
    echo -n "$passphrase" | pbcopy
    echo -e "\033[32m✓\033[0m Copied passphrase to clipboard: $passphrase"
}