#!/bin/bash

# Test script demonstrating multiple new features working together

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

echo "🎯 Testing New Features Combination..."

# Test fortune feature
check "devfortune works" bash -c "devfortune"

# Test ASCII art feature  
check "ascii-banner works" bash -c "ascii-banner 'DevContainer' | grep -E '.+'"

# Test git aliases (if git is available)
if command -v git >/dev/null 2>&1; then
    check "git shortcuts available" bash -c "git config --get alias.st"
fi

# Test dev tools
check "jq processes JSON" bash -c "echo '{\"test\": \"value\"}' | jq '.test'"
check "tree shows structure" bash -c "tree --version"

# Test shell theme
check "theme switcher works" bash -c "switch-theme | grep 'Available themes'"

# Test combined workflow
echo "🚀 Running combined workflow test..."

# Create a sample project structure
mkdir -p /tmp/test-project/src
cd /tmp/test-project

# Initialize git repo
if command -v git >/dev/null 2>&1; then
    git init
    echo "# Test Project" > README.md
    git add README.md
    git commit -m "Initial commit"
fi

# Generate project banner
echo "📝 Project banner:"
ascii-banner "Test Project"

# Show development tools info
echo "🛠️ Available tools:"
dev-tools-info

# Show a fortune
echo "💡 Developer wisdom:"
devfortune

echo "✅ All new features are working together!"

# Report results
reportResults