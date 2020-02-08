#!/bin/sh -l

sig=`cat /github.sig`
challenge=`ssh-keyscan -t rsa github.com 2>/dev/null | ssh-keygen -lf -`

if [ "$challenge" = "$sig" ]; then
    mkdir ~/.ssh/
    chmod 700 ~/.ssh/
    ssh-keyscan github.com 2>/dev/null >> ~/.ssh/known_hosts
    if [ "$1" = "" ]; then
        echo "No SSH key detected, attempting public checkout"
        git submodule update --init --recursive
    else
        echo "SSH key detected, attempting private checkout"
        echo "$1" > ~/.ssh/ssh.key
        chmod 600 ~/.ssh/ssh.key
        export GIT_SSH_COMMAND="ssh -i ~/.ssh/ssh.key"
        git submodule update --init --recursive
    fi;
else
    echo "Signature validation failed!"
    exit 1
fi;
