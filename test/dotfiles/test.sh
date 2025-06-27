#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "dotfiles-info command exists" test -f /usr/local/bin/dotfiles-info
check "dotfiles-info is executable" test -x /usr/local/bin/dotfiles-info

# Test that dotfiles-info runs without error
check "dotfiles-info runs successfully" dotfiles-info

echo "All dotfiles tests passed!"