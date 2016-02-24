#!/bin/bash

source /etc/profile

set -ex

JAVA_VERSION=${JAVA_VERSION:-$1}

cd /vagrant

source setup_java/setup_java.sh

setup_java $JAVA_VERSION

# verify that current java is the expected one
test_java_version java $JAVA_VERSION

# verify that installed java is current one
[[ "$JAVA" == "$(readlink -f $(which java))" ]]

# verify that $JAVA_HOME contains installed java
find "$JAVA_HOME" -name java | grep "$JAVA"
[[ "$(basename $JAVA_HOME)" != "jre" ]]

echo $0": SUCCESS"
