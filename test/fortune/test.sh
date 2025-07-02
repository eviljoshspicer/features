#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "devfortune command exists" bash -c "command -v devfortune"
check "devfortune produces output" bash -c "devfortune | grep -E '.+'"
check "devfortune output is reasonable length" bash -c "[ $(devfortune | wc -c) -gt 10 ]"

# Report results
reportResults