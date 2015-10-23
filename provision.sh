#!/bin/bash

set -xe

if apt-get --version; then
    apt-get update -y
    apt-get install -y git realpath

else
    if dnf --version; then
        dnf install -y git
    elif yum --version; then
        yum install -y git
    else
        echo "Unsupported system."
        exit 1
    fi
fi
