#!/usr/bin/env bash

# This script is used in CI and by molecule to lint the project.
#
# It runs the linters (alphabetically by command-name), and collects their
# output and return codes for display at the end of the script.
#
# If any one or more of the individual commands returns a nonzero value, then
# this script will too.
#
# Usage:
#
# - From the project root, run "./scripts/lint.sh" either locally in in CI
#   scripts and checks.
# - From the project root, run "molecule lint" (the script will also be run
#   automatically in "molecule test").

set +ex

echo ''

# Run ansible-lint check.
echo 'Starting ansible-lint...'

# ansible-lint supposedly works if passed a path, but it really doesn't look as
# though it does. So for now, lets find all the likely candidate files (yaml
# files not in roles, or in .venv) and ansible-lint each of them individually.
#
# This also means that (for the moment) the .ansible-lint file in the project
# root is ignored.
ANSIBLELINT_OUTPUT=$(find . -type f \
  -name '*.yml' \
  -not -path './.venv/*' \
  -not -path './roles/*' \
  -not -path './playbooks/roles/*' \
  -exec ansible-lint {} +)
ANSIBLELINT_RETURN="$?"

# Run flake8 check.
echo 'Starting flake8...'

FLAKE8_OUTPUT=$(flake8 ./tests/*/*.py)
FLAKE8_RETURN="$?"

# Run shellcheck check.
echo 'Starting shellcheck...'

SHELLCHECK_OUTPUT=$(shellcheck ./scripts/*)
SHELLCHECK_RETURN="$?"

# Run yamllint check.
echo 'Starting yamllint...'

YAMLLINT_OUTPUT=$(yamllint ./)
YAMLLINT_RETURN="$?"

echo ''

#
# Make it easy to output return codes and errors.
#
function output_errors {
  if [ "$2" -ne 0 ]; then
      echo "The '$1' command failed with return code '$2':"
      echo ''
      echo echo "$3" | awk '{print "\t" $0}'
      echo ''
  fi
}

#
# Output return codes and errors for each check, and for the script as a whole.
#
function finish {
  # Output errors--if any--for each of the individual commands.
  output_errors 'ansible-lint' "$ANSIBLELINT_RETURN" "$ANSIBLELINT_OUTPUT"
  output_errors 'flake8' "$FLAKE8_RETURN" "$FLAKE8_OUTPUT"
  output_errors 'shellcheck' "$SHELLCHECK_RETURN" "$SHELLCHECK_OUTPUT"
  output_errors 'yamllint' "$YAMLLINT_RETURN" "$YAMLLINT_OUTPUT"

  # Exit with an overall return code--this will be some nonzero value if any
  # of the individual commands returned a nonzero value.
  exit "$YAMLLINT_RETURN" \
    || "$ANSIBLE_RETURN" \
    || "$FLAKE8_RETURN" \
    || "$SHELLCHECK_OUTPUT"
}

trap finish EXIT
