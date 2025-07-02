#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "figlet installed" bash -c "command -v figlet"
check "ascii-banner command exists" bash -c "command -v ascii-banner"
check "welcome-banner command exists" bash -c "command -v welcome-banner"
check "ascii-banner produces output" bash -c "ascii-banner Test | grep -E '.+'"
check "welcome-banner produces colored output" bash -c "welcome-banner Hello | grep -E '.+'"

# Report results
reportResults