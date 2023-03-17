#!/bin/bash

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
