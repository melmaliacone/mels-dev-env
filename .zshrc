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

# Path to your oh-my-zsh installation.
export ZSH=/Users/melcone/.oh-my-zsh

# set default editor
export EDITOR='vim'

##### my startup functions ##################################################

# function path for my custom functions
export FPATH=~/.mel-zsh-functions:$FPATH

# aliases for custom functions
alias hbu='homebrew_sync'

# autocomplete
autoload -U +X autocomplete && autocomplete

# homebrew
autoload -U +X homebrew_sync && homebrew_sync

# gcloud sdk
autoload -U +X gcloud_sdk && gcloud_sdk

#############################################################################

##### aliases ###############################################################

# Homebrew authentication
export HOMEBREW_GITHUB_API_TOKEN=$(cat $HOME/.config/github/token);

# Add timestamp to history and remove command number
# h -<number of history items to print>, e.g. h -100
alias h='fc -lin'

# frequently used
alias b='cd -'
alias sz='source ~/.zshrc'

# functions for zshrc so i don't lose things
function create_zshrc_copy {
    file="zshrc-$(date)"
    printf "[alias: mzsh] making copy of old zshrc before editing...\nfile name: %s\n" $file && cp "/Users/melcone/.zshrc" "${file}" && code ~/.zshrc
}
alias mz='create_zshrc_copy'

# terraform
alias tf='terraform'
alias tfclean='rm -rf .terraform/ && rm *tfstate*'

# aws identity
alias aid='aws sts get-caller-identity'
alias did='unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN && unset AWS_PROFILE'
alias sso='aws sso login'

# python
alias python='python3'
alias pip='pip3'

# k8s
alias k='kubectl'

# docker
alias dk='docker'
alias drm='docker ps -q -a | xargs docker rm -f'
alias drmi='docker system prune -a'

#helm
alias hrm='helm uninstall $(helm ls -a --all-namespaces --short)'

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
alias gfp='git_checkout_fetch_pull $(git rev-parse --abbrev-ref origin/HEAD | cut -d "/" -f2) $(git branch --show-current)'
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

##### git functions #########################################################

# environment variable used to keep track of current git repo
# needed to prevent git_checkout_fetch_pull for running every time you change
# directories in the same git repo
export curr_git_repo=""

# alias builtin cd to new git_cd
alias cd='git_cd'

# calls builtin cd command
# if new directory is a git repo, sync local repo with origin
function git_cd {
    builtin cd "$@" && sync_git_repo
}

# check if the current directory is a git repo 
# AND that you're not changing directories in the same git repo
# if both conditions are true, run git_checkout_fetch_pull
# otherwise, reset the curr_git_repo environment variable to the empty string
function sync_git_repo {
    if ! is_git_repo; then
        if [[ $curr_git_repo != "" ]]; then
            set_curr_git_repo ""
        fi
        return
    fi

    default_branch=$(git rev-parse --abbrev-ref origin/HEAD | cut -d "/" -f2)
    current_branch=$(git branch --show-current)

    if is_new_git_repo; then
        stash_and_checkout_default_branch "${default_branch}" && \
        git_checkout_fetch_pull "${default_branch}" && \
        checkout_prev_branch_and_stash_pop "${current_branch}"
    fi
}

# stash any current changes and checkout default branch
function stash_and_checkout_default_branch {
    default_branch=$1
    git stash && git checkout "${default_branch}"
}

# fetch and pull changes from upstream
function git_checkout_fetch_pull {
    default_branch=$1

    git fetch --all -p && \
    git pull origin "${default_branch}"
}

# pop from your stash if it's not empty and then check out the previous branch
function checkout_prev_branch_and_stash_pop {
    current_branch=$1
    git checkout "${current_branch}"
    stash_size=$(git stash list | wc -l)
    if (( stash_size > 0 )); then
        git stash pop
    fi
}

# check if current directory is a git repo
function is_git_repo {
    [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) = true ]]
}

# check if you switched from one git repo to a different one
# can only be run inside a git repo directory
# otherwise git_repo_top_level will error
function is_new_git_repo {
    git_repo_top_level=$(git rev-parse --show-toplevel)
    if [[ "${git_repo_top_level}" != "${curr_git_repo}" ]]; then
        set_curr_git_repo "${git_repo_top_level}" && \
        return 0;
    else
        return 1;
    fi
}

# set curr_git_repo environment variable
# used to keep track of whether you're changing into a *new* git repo directory
function set_curr_git_repo {
    git_repo_top_level=$1
    export curr_git_repo=$git_repo_top_level
}

alias m2m='change_default_branch_to_main'

# run locally after changing repo default branch from master to main
function change_default_branch_to_main {
    git branch -m master main && \
    git fetch origin && \
    git branch -u origin/main main && \
    git remote set-head origin -a
}

#############################################################################

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="muse"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

source $ZSH/oh-my-zsh.sh

### Old aliases and such ####################################################

# git global config for first time set up
#touch ~/.prev_git_repo
#git config --global user.name "Mel Cone"
#git config --global user.email "melmaliacone@gmail.com"
#git config --global pull.rebase true
#git config --global user.signingkey <my signing key>
#git config --global commit.gpgsign true
#git config --global gpg.program /usr/local/MacGPG2/bin/gpg
#git config --global core.editor "vim"
