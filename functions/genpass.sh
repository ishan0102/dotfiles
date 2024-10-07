#!/bin/bash

genpass() {
    # Reset OPTIND in case getopts has been used previously in the shell session
    OPTIND=1

    local wordlist_file="${HOME}/.functions/data/wordlist.txt"
    local num_words=3
    local separator="-"

    # Special characters, numbers, etc.
    local special_chars="!@#$%^&*()_+"
    local numbers="0123456789"
    local lowercase="abcdefghijklmnopqrstuvwxyz"
    local uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    # Parse named arguments using getopts
    while getopts "w:s" opt; do
        case "$opt" in
            w) num_words=$OPTARG ;;
            s) separator=$OPTARG ;;
            *) echo "Usage: genpass [-w num_words] [-s separator]]" >&2; return 1 ;;
        esac
    done

    # Check if wordlist file exists
    if [ ! -f "$wordlist_file" ]; then
        echo "Error: Wordlist file not found at $wordlist_file" >&2
        return 1
    fi

    # Read words from file into an array
    IFS=$'\n' read -d '' -r -a words < "$wordlist_file"

    # Generate passphrase
    local passphrase=""
    for ((i=1; i<=num_words; i++)); do
        random_index=$((RANDOM % ${#words[@]}))
        passphrase+="${words[random_index]}"
        if [ $i -lt $num_words ]; then
            passphrase+="$separator"
        fi
    done

    # Append special characters to meet password complexity rules
    # Append one random lowercase letter
    passphrase+="${lowercase:$((RANDOM % ${#lowercase})):1}"
    # Append one random uppercase letter
    passphrase+="${uppercase:$((RANDOM % ${#uppercase})):1}"
    # Append one random number
    passphrase+="${numbers:$((RANDOM % ${#numbers})):1}"
    # Append one random special character
    passphrase+="${special_chars:$((RANDOM % ${#special_chars})):1}"

    # Copy to clipboard and print confirmation
    echo -n "$passphrase" | pbcopy
    echo -e "\033[32m✓\033[0m Copied passphrase to clipboard: $passphrase"
}
