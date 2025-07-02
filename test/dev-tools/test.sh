#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "dev-tools-info command exists" bash -c "command -v dev-tools-info"
check "jq is installed" bash -c "command -v jq"
check "curl is installed" bash -c "command -v curl"
check "tree is installed" bash -c "command -v tree"
check "htop is installed" bash -c "command -v htop"
check "dev-tools-info runs" bash -c "dev-tools-info | grep 'Dev Tools'"

# Report results
reportResults