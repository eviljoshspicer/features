#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "git-help command exists" test -f /usr/local/bin/git-help
check "git-help is executable" test -x /usr/local/bin/git-help

# Test basic git aliases are configured
check "git st alias exists" git config --global --get alias.st
check "git co alias exists" git config --global --get alias.co
check "git br alias exists" git config --global --get alias.br
check "git cm alias exists" git config --global --get alias.cm

# Test that git-help runs without error
check "git-help runs successfully" git-help

echo "All git-aliases tests passed!"