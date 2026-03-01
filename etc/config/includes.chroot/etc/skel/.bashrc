# ~/.bashrc — SemiCode OS default shell configuration

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Enable globstar
shopt -s globstar 2>/dev/null

# Colored prompt
if [ -x /usr/bin/tput ] && tput setaf 1 &>/dev/null; then
    PS1='\[\033[01;34m\]\w\[\033[00m\] \[\033[01;32m\]$\[\033[00m\] '
else
    PS1='\w \$ '
fi

# PATH additions
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:/opt/cargo/bin:$PATH"

# Aliases — Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Aliases — Modern CLI tools
alias ls='eza --icons --group-directories-first 2>/dev/null || ls --color=auto'
alias ll='eza -la --icons --group-directories-first 2>/dev/null || ls -la --color=auto'
alias cat='bat --style=plain 2>/dev/null || cat'
alias find='fd 2>/dev/null || find'
alias grep='rg 2>/dev/null || grep --color=auto'

# Aliases — AI tools
alias cc='claude'
alias cx='codex'

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Enable programmable completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    fi
fi

# Welcome message (only on first login)
if [ -z "$SEMICODE_WELCOMED" ]; then
    export SEMICODE_WELCOMED=1
    echo ""
    echo "  Welcome to SemiCode OS v2 \"Genesis\""
    echo "  Type 'semicode-ai-setup' to configure your AI coding tools."
    echo ""
fi
