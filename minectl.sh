#!/bin/sh

#
# check depepdencies
#

DEPENDENCIES="tmux curl jq"
missing_deps=""

for dependency in $DEPENDENCIES; do
    if ! command -v $dependency &> /dev/null
    then
        missing_deps="$missing_deps $dependency"
    fi
done

if [ "$missing_deps" != "" ]; then
    printf "\033[1;33m" # yellow color
    echo "Warning: Missing dependencies:$missing_deps. Please install it or else this program might not work as expected!"
    printf "\033[0m" # reset color
fi

#
# init stuff
#

export WORKDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ProgName=$(basename $0)

print_help_text() {
    echo "Usage: $ProgName <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    start"
    echo "    restart"
    echo "    list"
    echo "    generate"
    echo "    pull"
    echo "    killall (not recommended)"
    echo "    init"
    echo ""
    echo "For help with each subcommand run:"
    echo "$ProgName <subcommand> -h | --help"
}

#
# subcommand parsing
#

subcommand=$1

if [ "$subcommand" = "init" ]; then
    echo "$ chmod -R +x ./scripts/*"
    chmod -R +x ${WORKDIR}/scripts/*
fi

case $subcommand in
    "" | "-h" | "--help")
        print_help_text
    
        ;;
    *)
        shift
        ${WORKDIR}/scripts/subcommands/${subcommand} $@
        if [ $? = 127 ]; then
            printf "\033[0;31m" # red
            echo "Error: script ${subcommand} could not be found." >&2
            echo "       Run '$ProgName --help' for a list of known subcommands." >&2
            printf "\033[0m" # reset color
            exit 1
        fi
        ;;
esac
