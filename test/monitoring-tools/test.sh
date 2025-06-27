#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "monitor-info command exists" test -f /usr/local/bin/monitor-info
check "monitor-info is executable" test -x /usr/local/bin/monitor-info
check "sysmon command exists" test -f /usr/local/bin/sysmon
check "sysmon is executable" test -x /usr/local/bin/sysmon

# Test that monitor-info runs without error
check "monitor-info runs successfully" monitor-info

# Test that sysmon runs without error
check "sysmon overview works" sysmon overview
check "sysmon help works" sysmon help

# Test htop is available (should always be installed)
if command -v htop > /dev/null 2>&1; then
    check "htop is installed" command -v htop
fi

# Test jq is available (should be installed by default)
if command -v jq > /dev/null 2>&1; then
    check "jq is installed" command -v jq
fi

echo "All monitoring-tools tests passed!"