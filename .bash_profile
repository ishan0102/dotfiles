eval "$(/opt/homebrew/bin/brew shellenv)"

for file in ~/.{bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

alias ut="cd ~/Documents/UT/Senior"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Thoughts
alias thoughts="cd ~/Documents/Programming/Projects/thoughts; hugo-obsidian -input=content -output=assets/indices -index -root=.; hugo server --disableFastRender & open http://localhost:1313"

alias recruiting="cd ~/Documents/Internships/recruiting; ./parse.sh"
alias unreal="cd ~/Documents/Unreal/landing-page; cd backend && . venv/bin/activate && uvicorn main:app --reload"


export HISTSIZE=
export HISTFILESIZE=
