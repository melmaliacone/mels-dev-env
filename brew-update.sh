#!/bin/bash

# homebrew update and upgrade command
# unlink tfenv before upgrading, link after done, and then cleanup and doctor
alias hbu='
echo "\nupdating homebrew..." && brew update && \
echo "\nunlinking tfenv..." && brew unlink tfenv && \
echo "\nupgrading homebrew formulas..." && brew upgrade && \
echo "\nrelinking tfenv..." && brew link --overwrite tfenv && \
echo "\ncleaning up and running brew doctor..." && brew cleanup && brew doctor'