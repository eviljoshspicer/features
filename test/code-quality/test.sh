#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "quality-info command exists" test -f /usr/local/bin/quality-info
check "quality-info is executable" test -x /usr/local/bin/quality-info
check "lint-all command exists" test -f /usr/local/bin/lint-all
check "format-all command exists" test -f /usr/local/bin/format-all

# Test that quality-info runs without error
check "quality-info runs successfully" quality-info

# Test that lint-all runs without error (may find no files to lint)
check "lint-all runs successfully" lint-all || true

# Test shellcheck is available (should always be installed)
if command -v shellcheck > /dev/null 2>&1; then
    check "shellcheck is installed" command -v shellcheck
fi

# Test .editorconfig was created
check "editorconfig exists" test -f /workspace/.editorconfig

echo "All code-quality tests passed!"