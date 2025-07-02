#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "setup-shell-theme command exists" bash -c "command -v setup-shell-theme"
check "switch-theme command exists" bash -c "command -v switch-theme"
check "switch-theme lists themes" bash -c "switch-theme | grep 'Available themes'"
check "bashrc has theme setup" bash -c "grep -q 'Enhanced Shell Theme' ~/.bashrc"

# Report results
reportResults