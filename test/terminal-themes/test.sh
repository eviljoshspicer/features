#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "themes-info command exists" test -f /usr/local/bin/themes-info
check "themes-info is executable" test -x /usr/local/bin/themes-info

# Test that themes-info runs without error
check "themes-info runs successfully" themes-info

# Test Starship installation
if command -v starship > /dev/null 2>&1; then
    check "starship is installed" command -v starship
    check "starship config exists" test -f ~/.config/starship.toml || test -f /etc/skel/.config/starship.toml
fi

# Test neofetch installation  
if command -v neofetch > /dev/null 2>&1; then
    check "neofetch is installed" command -v neofetch
fi

echo "All terminal-themes tests passed!"