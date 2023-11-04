#!/bin/bash

# Style variables
bold=$(tput bold)
blue=$(tput setaf 4)
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to initialize the git repository
initialize_git() {
    if ! command_exists git; then
        echo "${bold}${red}Git could not be found. Please install it before proceeding.${reset}"
        return 1
    fi

    git init -b main
    git add .
    git commit -m "Initial commit"
}

# Function to create a GitHub repository
create_github_repo() {
    if ! command_exists gh; then
        echo "${bold}${red}GitHub CLI could not be found. Please install it before proceeding.${reset}"
        return 1
    fi

    if gh repo create "$directory" --source=. --remote=upstream --push --${visibility}; then
        echo "${bold}${green}Created the repo $directory on GitHub!${reset}"
    else
        echo "${bold}${red}Failed to create the GitHub repo. Please check your network connection and try again.${reset}"
        return 1
    fi
}

# Function to setup a Python project
setup_python_project() {
    echo ".pre-commit-config.yaml" > .gitignore
    python3 -m venv venv
    source venv/bin/activate
    pre-commit install
    echo "venv/" >> .gitignore
}

# Main function to make a git repository
mkgit() {
    # Ask for the directory name
    echo -n "${bold}${blue}Please enter the directory name: ${reset}"
    read directory
    if test -d "$directory"; then
        echo "${bold}${red}Error: Folder already exists.${reset}"
        return 1
    fi

    # Make sure this is running in the Documents folder
    if ! [[ "$(pwd)" =~ ~/Documents.*$ ]]; then
        echo "${bold}${red}Error: Please navigate to the documents folder before running this script.${reset}"
        return 1
    fi

    # Create a local directory and enter it
    mkdir "$directory" && cd "$directory"

    # Ask for repository visibility
    echo -n "${bold}${blue}Should the repository be public or private? (public/private): ${reset}"
    read visibility
    while [[ "$visibility" != "public" && "$visibility" != "private" ]]; do
        echo "${bold}${red}Invalid input. Please enter either 'public' or 'private': ${reset}"
        read visibility
    done

    # Ask for README contents
    echo -n "${bold}${blue}What would you like the README to say?: ${reset}"
    read readme_content
    echo "$readme_content" > README.md

    # Default .gitignore contents
    echo ".vscode/" >> .gitignore

    # Check if it's a Python project
    echo -n "${bold}${blue}Is this a Python project? (yes/no): ${reset}"
    read is_python_project
    if [[ "$is_python_project" == "yes" ]]; then
        setup_python_project
    fi

    # Ask for vscode settings
    echo -n "${bold}${blue}Would you like to add a .vscode/settings.json file? (yes/no): ${reset}"
    read vscode_answer
    if [[ "$vscode_answer" == "yes" ]]; then
        mkdir -p ".vscode" && touch ".vscode/settings.json"
    fi

    # Initialize local git repo
    initialize_git

    # Prepare for linking local repo to GitHub
    create_github_repo
}
