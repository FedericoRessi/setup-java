#!/bin/bash

set -xe

source /etc/profile

if apt-get --version; then
    apt-get update -y
    apt-get install -y realpath
fi
