#!/bin/bash

set -eu

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echoerr() { echo "$@" 1>&2; } # Echo text to stderr

# Setup Python
"${THIS_DIR}/python3" --neovim-setup

# Setup Ruby
"${THIS_DIR}/ruby" --neovim-setup
