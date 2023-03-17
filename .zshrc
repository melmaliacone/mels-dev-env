### paths and vars #############################################################

# If you come from bash you might have to change your $PATH.
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/melcone/.oh-my-zsh

# set default editor
export EDITOR='vim'

# homebrew
export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH

# linkerd
export PATH=$PATH:$HOME/.linkerd2/bin

# node
export NODE_PATH='/usr/local/lib/node_modules'

# golang
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
## turn on go modules
export GO111MODULE=on

# K9s uses 256 colors terminal mode, make sure TERM is set accordingly
export TERM=xterm-256color

# Homebrew authentication
export HOMEBREW_GITHUB_API_TOKEN=$(<>)

### my startup functions #######################################################

# function path for my custom functions
export FPATH=~/.mel-zsh-functions:$FPATH

# aliases for custom functions
alias hbu='homebrew_sync'

# autocomplete
autoload -U +X autocomplete && autocomplete

# golang version
autoload -U +X print_golang_version

# homebrew
autoload -U +X homebrew_sync && homebrew_sync

# setup direnv in zsh
eval "$(direnv hook zsh)"

### aliases ####################################################################

# Add timestamp to history and remove command number
# h -<number of history items to print>, e.g. h -100
alias h='fc -lin'

# frequently used
alias b='cd -'
alias sz='source ~/.zshrc'

# python
alias python='python3'
alias pip='pip3'
alias python-config='python3-config'

# terraform
alias tf='terraform'
alias tfclean='rm -rf .terraform/ && .terraform.lock.hcl && rm *tfstate*'

# aws
alias awsid='aws sts get-caller-identity'
alias did='unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE AWS_REGION'
alias cawsp='echo $AWS_PROFILE && echo $AWS_REGION && echo $AWS_ACCOUNT'

# code repo shortcuts
alias mc='cd ~/code'

# personal code
alias mpc='cd ~/code/other-code/personal'
alias mde='cd ~/code/other-code/personal/mels-dev-env'

# kubernetes
alias k='kubectl'
## sort pods by restart count with most restarts at bottom
alias kgpr="kubectl get pods --sort-by='.status.containerStatuses[0].restartCount' -A"
## sort pods by creation time
alias kgps="kubectl get pods --sort-by='.metadata.creationTimestamp' -A"
## get all pods that are in a bad state
alias kgpb='kubectl get pods --field-selector status.phase!=Running,status.phase!=Succeeded -A'
## get all evicted pods
alias kge="kubectl get pod -A | grep Evicted | awk '{print $1}'"
## eks
export AWS_SDK_LOAD_CONFIG=1
alias nv='eks-node-viewer'

# docker
alias dk='docker'
alias drm='docker ps -q -a | xargs docker rm -f'
alias drmi='docker system prune -a --force --volumes'
alias dpr='docker image prune --force'
alias dspr='docker system prune -a --force'

# helm
alias hrm='helm uninstall $(helm ls -a --all-namespaces --short)'

# istio
alias ictl='istioctl'

# git global config for first time set up
#git config --global user.name "Mel Cone"
#git config --global user.email "<>"
#git config --global pull.rebase true
#git config --global user.signingkey <>
#git config --global commit.gpgsign true
#git config --global gpg.program /usr/local/MacGPG2/bin/gpg
#git config --global init.templateDir ~/.git-template
#git config --global core.editor "vim"
#git config --global --add url."git@github.com:".insteadOf "https://github.com/"

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
alias gcot='git checkout --track'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gf='git fetch --all -p'
alias gfp='git_checkout_fetch_pull $(git rev-parse --abbrev-ref origin/HEAD | cut -d "/" -f2)'
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

### git functions ##############################################################

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

### kubernetes functions #######################################################

# alias kubectx to new kubectx_with_current_context
alias kubectx='kubectx_with_current_context'

# calls kubectx command and updates env vars with info on current kube context
# needed for iTerm2 status bar components
function kubectx_with_current_context {
    kubectx_binary=$(brew unlink kubectx --dry-run | grep -m 1 kubectx)
    $kubectx_binary "$@" && set_current_kube_context_vars
}

function set_current_kube_context_vars {
    KUBE_CLUSTER=$(kubectl config view --minify --flatten -o jsonpath={..context.cluster}; echo)
    export KUBE_CLUSTER_NAME=$(cut -d "/" -f2 <<< $KUBE_CLUSTER)
    export KUBE_CLUSTER_ACCOUNT=$(cut -d ":" -f5 <<< $KUBE_CLUSTER)
    export KUBE_NS=$(kubectl config view --minify -o jsonpath='{..namespace}'; echo)
}

# alias kubens to new kubens_with_current_ns
alias kubens='kubens_with_current_ns'

# calls kubens command updates kube context namespace env var
# needed for iTerm2 status bar components
function kubens_with_current_ns {
    kubens_binary=$(brew unlink kubectx --dry-run | grep -m 1 kubens)
    $kubens_binary "$@" && set_current_kube_context_vars
}

function set_kube_context_ns {
    export KUBE_NS=$(kubectl config view --minify -o jsonpath='{..namespace}'; echo)
}

##### aws functions ###########################################################

# interactively select AWS profile from my aws config
function awsp() {
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE AWS_REGION
    AWS_PROFILE=$(grep -w profile $HOME/.aws/config | sed "s/[][]//g" | cut -d ' ' -f 2 | sort | fzf)
    export AWS_PROFILE
    AWS_REGION=$(echo "us-west-2\nus-east-1" | sort | fzf)
    export AWS_REGION
    # update env var to use in iTerm2 status bar components
    export AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
}

# calls awsp function and then logs into aws via sso
function awsp_sso () {
    awsp
    aws sso login
}

################################################################################

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
# I don't want Oh My Zsh thinking all my aliases are typos
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

# Added by Docker Desktop
source /Users/melcone/.docker/init-zsh.sh || true

# Added by iTerm2 after installing shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# set user vars to use in status bar components
iterm2_print_user_vars() {
    iterm2_set_user_var awsProfile $AWS_PROFILE
    iterm2_set_user_var awsRegion $AWS_REGION
    iterm2_set_user_var awsAccount $AWS_ACCOUNT
    iterm2_set_user_var kubeClusterName $KUBE_CLUSTER_NAME
    iterm2_set_user_var kubeClusterAccount $KUBE_CLUSTER_ACCOUNT
    iterm2_set_user_var kubeNamespace $KUBE_NS
}
