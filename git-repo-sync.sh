#!/bin/bash

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