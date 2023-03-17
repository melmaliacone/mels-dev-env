# Mel's Developer Environment Configuration

A collection of scripts, config, etc. that I've written myself or collected from stack overflow (or coworkers) over the years.

## `zsh` configuration

My [~/.zshrc](.zshrc) file

## `Brewfile`

[`Brewfile`](Brewfile) contains all my Homebrew formulae

To generate your own `Brewfile` to save your homebrew configuration

```bash
brew bundle dump
```

To install my formulae

```bash
brew bundle
```

## `git-repo-sync.sh`

### Automatically sync your local git repos with their upstream default branch

Works by aliasing the builtin `cd` command to my `git_cd` function, which runs a bunch of `git` commands under the hood.

The function handles fetching, pulling, and then gracefully returning you to your originally checked out branch and state.

[Check out the full script here](scripts/git-repo-sync.sh).

It lives directly in my `.zshrc` file.

## `.mel-zsh-functions/`

Includes functions I run automatically when I start a new terminal

### Creating your own custom functions

The steps below walk through how to make custom functions available outside of aliasing them **and** how to run them automatically when you start a new terminal session.

#### Setup steps

Mostly copied from a [Stack Exchange post](https://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh))

1. My `~/.mel-zsh-functions` directory contains my custom functions, with a file for each function.  
   To get this working for yourself:
   * Your directory can be called anything and can be located anywhere on your computer
   * The function script file must be named the name of the function, **with no file extension**
   * The file itself can contain any `bash/zsh` scripting and doesn't need to be wrapped in `function <function_name> {}` or contain `#!/bin/bash`
   * `zsh` is designed so that **the name of the file is the function name**
1. Add or update the `FPATH` environment variable to include the directory with your functions.  
   For example, I added the line below to my `~/.zshrc`

   ```bash
   export FPATH=~/.mel-zsh-functions:$FPATH
   ```

   >:warning: Do **not** put any quotes around the `FPATH` value. It will not work.

   At this point, you can call your function(s), assuming you've opened a new terminal window or sourced your `~/.zshrc`. For example, if I want to run the function `homebrew_sync`, I just type `homebrew_sync` in my terminal window, hit enter, and it runs.
1. For any functions you'd like to run automatically whenever a new terminal window is opened, you need to add a line to your `~/.zshrc`

   ```bash
   autoload -U +X <your_function> && <your_function>
   ```

### My custom functions

#### `autocomplete`

[Enable autocomplete in `zsh`](.mel-zsh-functions/autocomplete).

>Prequisites

* `python` installed
* Run these commands

  ```bash
  brew install bash-completion
  pip install argcomplete
  activate-global-python-argcomplete
  ```

Partially [taken from stack overflow](https://stackoverflow.com/questions/3249432/can-a-bash-tab-completion-script-be-used-in-zsh).

#### `homebrew_sync`

>Prequisites

* [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

[Update Homebrew, upgrade your formulae, and then run `brew doctor` and `brew cleanup`](.mel-zsh-functions/homebrew_sync).

Sets `HOMEBREW_GITHUB_API_TOKEN` to prevent homebrew use limits.
