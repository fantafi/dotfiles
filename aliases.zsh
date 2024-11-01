# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias reloadshell="omz reload"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/opt/homebrew/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias phpstorm='open -a /Applications/PhpStorm.app "`pwd`"'
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias compile="commit 'compile'"
alias version="commit 'version'"
alias c="clear"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias projects="cd $HOME/Code"
alias sites="cd $HOME/Herd"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run dev"

# Docker
alias docker-composer="docker-compose"

# Git
alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force-with-lease"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias prune="git fetch --prune"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"

# VNG
#!/bin/bash

function votp() {
    local op_vault="VNG"
    local op_item="${1:-VNG OTP}"
    local clipboard_duration=30

    # Check if op command is available
    if ! command -v op &> /dev/null; then
        echo "Error: 1Password CLI (op) is not installed or not in PATH." >&2
        return 1
    fi

    # Check if jq command is available
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is not installed or not in PATH." >&2
        return 1
    fi

    # Fetch item info
    local item_info
    item_info=$(op item get "${op_item}" --vault "${op_vault}" --format=json 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to retrieve item '${op_item}' from vault '${op_vault}'." >&2
        return 1
    fi

    # Extract PIN and OTP
    local pin otp
    pin=$(echo "${item_info}" | jq -r '.fields[] | select(.label=="password") | .value')
    otp=$(echo "${item_info}" | jq -r '.fields[] | select(.label=="one-time password") | .totp')

    if [ -z "$pin" ] || [ -z "$otp" ]; then
        echo "Error: Failed to extract PIN or OTP from the item." >&2
        return 1
    fi

    # Combine PIN and OTP
    local password="$pin$otp"

    # Copy to clipboard
    if ! echo -n "${password}" | pbcopy; then
        echo "Error: Failed to copy password to clipboard." >&2
        return 1
    fi

    echo "Password copied to clipboard. Will clear in ${clipboard_duration} seconds."
    # echo "PIN: ${pin}"
    # echo "OTP: ${otp}"

    # Clear clipboard after a delay
    (sleep ${clipboard_duration} && echo -n '' | pbcopy) &

    return 0
}
