# Mel's Dev Config

A collection of scripts, files, etc. that I've written myself or collected from stack overflow over the years.

I use them in my dev environment (at my full time job) to make my life easier.

## `zsh` configuration

My [~/.zshrc](.zshrc) file

## `Brewfile`

My [`Brewfile`](Brewfile) contains all my Homebrew formulae

To install my formulae

```bash
brew bundle
```

To generate your own `Brewfile` to save your homebrew configuration

```bash
brew bundle dump
```

## Creating your own custom functions

### My `.mel-zsh-functions` directory for custom functions

The steps below walk through how to make custom functions available outside of aliasing them **and** how to run them automatically when you start a new terminal session.

#### Setup steps (mostly copied from a [Stack Exchange post](https://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh))

1. My `~/.mel-zsh-functions` directory contains my custom functions, with a file for each function.
</br>To get this working for yourself:
   * Your directory can be called anything and can be located anywhere on your computer
   * The function script file must be named the name of the function (with no file extension)
   * The file itself can contain any `bash/zsh` scripting and doesn't need to be wrapped in `function <function_name> {}` or contain `#!/bin/bash`
   * `zsh` is designed so that **the name of the file is the function name**
1. Add or update the `FPATH` environment variable to include the directory with your functions.
   </br> For example, I added the line below to my `~/.zshrc`

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

[Script to enable autocomplete in `zsh`](.mel-zsh-functions/autocomplete)

#### `gcp_sdk`

[Script to setup gcloud sdk via Homebrew](.mel-zsh-functions/gcp_sdk)

#### `homebrew_sync`

[Script to update Homebrew, upgrade your formulae, and then run `brew doctor` and `brew cleanup`](.mel-zsh-functions/homebrew_sync)

I have this aliased in my `~/.zshrc` and configured to run automatically when I open a new terminal window.

### Automatically sync your git repos with `origin/<default_branch>`

#### `git-repo-sync` script

I have this in my `~/.zshrc`.

It works by using the builtin `cd` command, running my functions after, and aliasing `cd`. [Check out the script for more details](git-repo-sync.sh) and to see everything that it does.
