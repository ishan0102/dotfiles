#!/bin/bash

# SSHGo - SSH into accounts without memorizing hostnames
function sshgo() {
    # Define the colors and styles using ANSI escape codes
    local RED="\033[31m"
    local GREEN="\033[32m"
    local YELLOW="\033[33m"
    local CYAN="\033[36m"
    local BOLD="\033[1m"
    local RESET="\033[0m"

    # Define your SSH accounts as indexed arrays
    local labels=("1" "2" "3") # Labels for each account
    local descriptions=("Michael's GPU" "Compling GPU Cluster" "Digital Ocean") # Descriptions for each account
    local commands=("ishan0102@172.92.164.155" "irs428@compling.la.utexas.edu" "root@178.128.135.139") # SSH commands

    # Print a pretty list of your SSH accounts
    echo -e "${GREEN}${BOLD}SSH Accounts:${RESET}"
    echo -e "${CYAN}-------------${RESET}"
    for i in "${!labels[@]}"; do
        echo -e "[${YELLOW}${BOLD}${labels[$i]}${RESET}] ${CYAN}${descriptions[$i]}${RESET}"
    done
    echo -e "${CYAN}-------------${RESET}"

    # Prompt the user to select an account
    read -p "Enter the number corresponding to the account you want to SSH into: " selection

    # Check if the entered number is valid
    if [[ ! " ${labels[@]} " =~ " ${selection} " ]]; then
        echo -e "${RED}Invalid selection. Please try again.${RESET}"
        return 1
    fi

    # Find the index of the selected label
    local index
    for i in "${!labels[@]}"; do
        if [[ "${labels[$i]}" == "${selection}" ]]; then
            index="$i"
            break
        fi
    done

    # Copy computer password into clipboard
    echo $COMPUTER_PASSWORD | pbcopy

    # SSH into the selected account
    echo -e "${GREEN}Connecting to ${descriptions[$index]}...${RESET}"
    ssh ${commands[$index]}
}