#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "git is available" bash -c "command -v git"
check "git-help-aliases command exists" bash -c "command -v git-help-aliases"
check "git status alias exists" bash -c "git config --get alias.st"
check "git checkout alias exists" bash -c "git config --get alias.co"
check "git help aliases runs" bash -c "git-help-aliases | grep 'Git Aliases'"

# Report results
reportResults