#!/usr/bin/env bash

# Used to set up a virtualenv environment for local development. Encapsulated
# in script to avoid Github Dependabot warnings about expired package versions
# that we'd get if we used a requirements.txt file.
#
# Actual script installation is a separate file, install-python-dependencies.sh
# so that it can be used directly in CI or simply directly according to the
# install/test environment.

set -e

venv_path=".venv"
venv_activate="$venv_path/bin/activate"
venv_deactivate="deactivate"

# Create a brand-new virtualenv directory.
rm -rf "$venv_path" && virtualenv -p python3 "$venv_path"

# Activate virtualenv within this process.
#
# Shellcheck wants to be able to source this file itself, but can't do so when
# the path is created at runtime. Oh well.
#
# shellcheck disable=SC1090
source "$venv_activate"

# Install packages as needed.
./scripts/install-python-dependencies.sh

# Deactviate virtualenv within this process.
"$venv_deactivate"

# Tell the user what to do.
echo ""
echo "Virtualenv prepared and packages installed. Use '. $venv_activate' to get started and '$venv_deactivate' when finished."
echo ""
