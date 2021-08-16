# If you come from bash you might have to change your $PATH.
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH

# golang paths
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# homebrew path
export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH

# other paths
export PATH=$PATH:$HOME/.linkerd2/bin
export NODE_PATH='/usr/local/lib/node_modules'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/melcone/code/gcp/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/melcone/code/gcp/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/melcone/code/gcp/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/melcone/code/gcp/google-cloud-sdk/completion.zsh.inc'; fi

# Path to your oh-my-zsh installation.
export ZSH=/Users/melcone/.oh-my-zsh

# set default editor
export EDITOR='vim'

# autocomplete
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
source /usr/local/etc/bash_completion.d/python-argcomplete

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# Add timestamp to history and remove command number
# h -<number of history items to print>, e.g. h -100
alias h='fc -lin'

# frequently used
alias b='cd -'
alias zshrc="code ~/.zshrc"

# terraform
alias tf='terraform'
alias tfclean='rm -rf .terraform/ && rm *tfstate*'

# aws identity
alias awsid='aws sts get-caller-identity'
alias delid='unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN'

# homebrew update and upgrade command
# unlink tfenv before upgrading, link after done, and then cleanup and doctor
alias hbu='
echo "\nupdating homebrew..." && brew update && \
echo "\nunlinking tfenv..." && brew unlink tfenv && \
echo "\nupgrading homebrew formulas..." && brew upgrade && \
echo "\nrelinking tfenv..." && brew link --overwrite tfenv && \
echo "\ncleaning up and running brew doctor..." && brew cleanup && brew doctor'

# python
alias python='python3'
alias pip='pip3'

# k8s
alias k='kubectl'
alias dk='docker'

# docker
alias drm='docker ps -q -a | xargs docker rm -f'
alias drmi='docker rmi –f $(docker images | grep "^<none>" | awk '"'"'{print $3}'"'"')'

#helm
alias hrm='helm uninstall $(helm ls -a --all-namespaces --short)'

# git global config for first time set up
#git config --global user.name "Mel Cone"
#git config --global user.email "melmaliacone@gmail.com"
#git config --global pull.rebase true
#git config --global user.signingkey <signing key>
#git config --global commit.gpgsign true
#git config --global gpg.program /usr/local/MacGPG2/bin/gpg
#git config --global core.editor "vim"

#### git functions ####

# automatically gfp if directory is a git repo
alias cd='gitCD'

# calls builtin cd command
# if new directory is a git repo, sync local repo with origin
function gitCD {
    builtin cd "$@" && gfpIfGitRepo
}

# stash any current changes and attempt to checkout main
# if that fails, checkout master
function stashAndCheckoutBaseBranch {
    if ! (git stash && git checkout main) 2> /dev/null; then
        git checkout master
    fi
}

# run stashAndCheckoutBaseBranch, fetch, and pull
function gitCheckoutFetchPull {
    stashAndCheckoutBaseBranch && \
    git fetch --all -p && \
    git pull origin $(git branch --show-current) && \
}

# check if the current directory is a git repo
# if it is, run gitCheckoutFetchPull
function gfpIfGitRepo {
    if (git rev-parse --is-inside-work-tree) > /dev/null 2>&1; then
        gitCheckoutFetchPull
    fi
}

# git aliases
alias ga='git add'
alias gb='git branch'
alias gbd='git branch -D'
alias gc='git commit -m'
alias gca='git commit --amend --no-edit'
alias gcl='git clone'
alias gclean='git stash && git clean -dffx'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -b mel-local --track'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gf='git fetch --all -p'
alias gfp='git fetch --all -p && git pull origin main'
alias gfpm='git fetch --all -p && git pull origin master'
alias gl='git log --decorate'
alias gp='git pull'
alias gpu='git push'
alias gpuf='git push --force'
alias gr='git remote -v'
alias gra='git remote add'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grh='git reset --hard'
alias grm='git rm'
alias grv='git revert'
alias gs='git status --short'
alias gsq='git rebase -i'
alias gst='git stash'
alias gstf='git stash push'
alias gstp='git stash pop'
alias gstl='git stash list'

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="muse"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
#if [[ -n $SSH_CONNECTION ]]; then
#    export EDITOR='vim'
#else
#    export EDITOR='mvim'
#fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"