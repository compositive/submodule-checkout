#!/bin/sh -l

sig=`cat /github.sig`
challenge=`ssh-keyscan -t rsa github.com 2>/dev/null | ssh-keygen -lf -`

echo "Working as user $(whoami) [$HOME]"

if [ "$challenge" = "$sig" ]; then
    mkdir "$HOME/.ssh/"
    chmod 700 "$HOME/.ssh/"
    ssh-keyscan github.com 2>/dev/null >> "$HOME/.ssh/known_hosts"

    if [ "$1" = "" ]; then
        echo "No SSH key detected, attempting public checkout"
    else
        echo "SSH key detected, attempting private checkout"
        echo "$1" > "$HOME/.ssh/ssh.key"
        chmod 600 "$HOME/.ssh/ssh.key"
        export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/ssh.key"
    fi;

    git submodule update --init --recursive
else
    echo "Signature validation failed!"
    exit 1
fi;
