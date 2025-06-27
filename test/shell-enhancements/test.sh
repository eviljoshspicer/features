#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "shell-help command exists" test -f /usr/local/bin/shell-help
check "shell-help is executable" test -x /usr/local/bin/shell-help
check "shell enhancements file exists" test -f /usr/local/share/shell-enhancements.sh

# Test that aliases are loaded by checking if they're in the enhancement file
check "ll alias defined" grep -q "alias ll=" /usr/local/share/shell-enhancements.sh
check "mkcd function defined" grep -q "mkcd()" /usr/local/share/shell-enhancements.sh
check "extract function defined" grep -q "extract()" /usr/local/share/shell-enhancements.sh

# Test that shell-help runs without error
check "shell-help runs successfully" shell-help

echo "All shell-enhancements tests passed!"