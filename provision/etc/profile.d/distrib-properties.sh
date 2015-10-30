
DISTRIB_ID="Unknown"
DISTRIB_RELEASE="Unknown"
DISTRIB_CODENAME="unknown"
DISTRIB_DESCRIPTION="Unknown Linux Distribution"
DISTRIB_INSTALLER="false"

function read_variable {
    local FILE_NAME="$1"
    local VARIABLE_NAME="$2"
    grep "$VARIABLE_NAME" "$FILE_NAME" | cut -d '=' -f 2
}


if [ -r  /etc/lsb-release ]; then
    # Ubuntu way
    export DISTRIB_ID=$(read_variable /etc/lsb-release DISTRIB_ID)
    export DISTRIB_RELEASE=$(read_variable /etc/lsb-release DISTRIB_RELEASE)
    export DISTRIB_CODENAME=$(read_variable /etc/lsb-release DISTRIB_CODENAME)
    export DISTRIB_DESCRIPTION=$(read_variable /etc/lsb-release DISTRIB_DESCRIPTION)

elif [ -r /etc/os-release ]; then
    # Redhat way
    export DISTRIB_ID=$(read_variable /etc/os-release NAME)
    export DISTRIB_RELEASE=$(read_variable /etc/os-release VERSION)
    export DISTRIB_CODENAME=$(read_variable /etc/os-release ID)$DISTRIB_RELEASE
    export DISTRIB_DESCRIPTION=$(read_variable /etc/os-release PRETTY_NAME)

fi

if which apt-get 2> /dev/null; then
    export DISTRIB_INSTALLER="apt-get install -y"

elif which dnf 2> /dev/null; then
    export DISTRIB_INSTALLER="dnf install -y"

elif which yum 2> /dev/null; then
    export DISTRIB_INSTALLER="yum install -y"

else
    echo "Unsupported distribution."
    cat /etc/*-release
fi

function is_ubuntu {
    [[ "$DISTRIB_ID" == "Ubuntu" ]]
}

function is_fedora {
    [[ "$DISTRIB_ID" == "Fedora" ]]
}

function is_redhat {
    [[ "$DISTRIB_ID" == "Redhat" ]]
}

function install_package {
    $DISTRIB_INSTALLER "$@"
}
