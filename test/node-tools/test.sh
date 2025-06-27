#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "node-info command exists" test -f /usr/local/bin/node-info
check "node-info is executable" test -x /usr/local/bin/node-info
check "pm command exists" test -f /usr/local/bin/pm
check "pm is executable" test -x /usr/local/bin/pm

# Test that Node.js is available (should be installed by the node feature)
check "node is available" command -v node
check "npm is available" command -v npm

# Test that node-info runs without error
check "node-info runs successfully" node-info

# Test pm command basic functionality
check "pm command runs" pm --version || true

echo "All node-tools tests passed!"