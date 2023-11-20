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

# Function to print a step message
print_step() {
    echo "${bold}${blue}=> $1${reset}"
}

# Function to print success message
print_success() {
    echo "${bold}${green}$1${reset}"
}

# Function to print error message
print_error() {
    echo "${bold}${red}$1${reset}"
}

# Function to initialize the git repository
initialize_git() {
    if ! command_exists git; then
        print_error "Git could not be found. Please install it before proceeding."
        return 1
    fi

    print_step "Initializing the git repository..."
    git init -b main
    
    # Setup Python project if applicable
    if [[ "$is_python_project" == "yes" ]]; then
        setup_python_project
    fi

    git add .
    git commit -m "Initial commit"
    print_success "Git repository initialized successfully."
}

# Function to setup a Python project
setup_python_project() {
    print_step "Setting up the Python project environment..."

    # Create .gitignore
    echo "venv/" >> .gitignore

    # Create the virtual environment and activate it
    python3 -m venv venv
    source venv/bin/activate
    print_success "Python virtual environment created and activated."

    # Create .pre-commit-config.yaml with the provided configuration
    cat <<EOF > .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
  - repo: https://github.com/bwhmather/ssort
    rev: v0.11.6
    hooks:
      - id: ssort
  - repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
      - id: isort
        args: ["--profile", "black", "--filter-files"]
  - repo: https://github.com/psf/black
    rev: 23.3.0
    hooks:
      - id: black
        args: ["--line-length", "120"]
EOF

    # Install pre-commit hooks
    pre-commit install
    print_success "Pre-commit hooks installed."
}

# Function to create a GitHub repository
create_github_repo() {
    if ! command_exists gh; then
        print_error "GitHub CLI could not be found. Please install it before proceeding."
        return 1
    fi

    print_step "Creating the GitHub repository..."
    if gh repo create "$directory" --source=. --remote=upstream --push --${visibility}; then
        print_success "Created the repo $directory on GitHub!"
    else
        print_error "Failed to create the GitHub repo. Please check your network connection and try again."
        return 1
    fi
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

    # Open VS Code
    code .
}
