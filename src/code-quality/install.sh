#!/bin/sh
set -e

echo "Activating feature 'code-quality'"

# Update package lists
apt-get update

# Install base packages
apt-get install -y curl wget

# Install Node.js tools if npm is available
if command -v npm > /dev/null 2>&1; then
    echo "Installing Node.js code quality tools..."
    
    # Install Prettier if enabled
    if [ "${INSTALLPRETTIER}" = "true" ]; then
        echo "Installing Prettier..."
        npm install -g prettier
    fi
    
    # Install ESLint if enabled
    if [ "${INSTALLESLINT}" = "true" ]; then
        echo "Installing ESLint..."
        npm install -g eslint
    fi
    
    # Install markdownlint if enabled
    if [ "${INSTALLMARKDOWNLINT}" = "true" ]; then
        echo "Installing markdownlint..."
        npm install -g markdownlint-cli
    fi
else
    echo "npm not found, skipping Node.js tools installation"
fi

# Install Python tools if pip is available
if command -v pip > /dev/null 2>&1 || command -v pip3 > /dev/null 2>&1; then
    echo "Installing Python code quality tools..."
    
    # Use pip3 if available, otherwise pip
    PIP_CMD="pip3"
    if ! command -v pip3 > /dev/null 2>&1; then
        PIP_CMD="pip"
    fi
    
    # Install Black if enabled
    if [ "${INSTALLBLACK}" = "true" ]; then
        echo "Installing Black..."
        $PIP_CMD install black
    fi
    
    # Install Flake8 if enabled
    if [ "${INSTALLFLAKE8}" = "true" ]; then
        echo "Installing Flake8..."
        $PIP_CMD install flake8
    fi
    
    # Install pre-commit if enabled
    if [ "${INSTALLPRECOMMIT}" = "true" ]; then
        echo "Installing pre-commit..."
        $PIP_CMD install pre-commit
    fi
else
    echo "pip not found, skipping Python tools installation"
fi

# Install Shellcheck if enabled
if [ "${INSTALLSHELLCHECK}" = "true" ]; then
    echo "Installing Shellcheck..."
    apt-get install -y shellcheck
fi

# Create default .editorconfig if enabled
if [ "${INSTALLEDITORCONFIG}" = "true" ]; then
    echo "Creating default .editorconfig..."
    cat > /workspace/.editorconfig << 'EOF'
# EditorConfig is awesome: https://EditorConfig.org

# top-most EditorConfig file
root = true

# Unix-style newlines with a newline ending every file
[*]
end_of_line = lf
insert_final_newline = true
charset = utf-8
trim_trailing_whitespace = true

# Matches multiple files with brace expansion notation
# Set default charset
[*.{js,py,json,yml,yaml,html,css,scss,md}]
charset = utf-8

# 4 space indentation
[*.{py,java,r,R}]
indent_style = space
indent_size = 4

# 2 space indentation
[*.{js,jsx,ts,tsx,json,yml,yaml,html,css,scss,md}]
indent_style = space
indent_size = 2

# Tab indentation (no size specified)
[Makefile]
indent_style = tab

# Indentation override for all JS under lib directory
[lib/**.js]
indent_style = space
indent_size = 2

# Matches the exact files either package.json or .travis.yml
[{package.json,.travis.yml}]
indent_style = space
indent_size = 2
EOF
fi

# Create quality check scripts
cat > /usr/local/bin/lint-all << 'EOF'
#!/bin/bash
# Run all available linters on the current directory

echo "🔍 Running Code Quality Checks..."
echo "================================"

# JavaScript/TypeScript with ESLint
if command -v eslint > /dev/null 2>&1; then
    echo ""
    echo "📝 ESLint (JavaScript/TypeScript):"
    if find . -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | head -1 | grep -q .; then
        eslint . --ext .js,.jsx,.ts,.tsx || echo "  ESLint found issues"
    else
        echo "  No JS/TS files found"
    fi
fi

# Python with Flake8
if command -v flake8 > /dev/null 2>&1; then
    echo ""
    echo "🐍 Flake8 (Python):"
    if find . -name "*.py" | head -1 | grep -q .; then
        flake8 . || echo "  Flake8 found issues"
    else
        echo "  No Python files found"
    fi
fi

# Shell scripts with Shellcheck
if command -v shellcheck > /dev/null 2>&1; then
    echo ""
    echo "🐚 Shellcheck (Shell scripts):"
    if find . -name "*.sh" | head -1 | grep -q .; then
        find . -name "*.sh" -exec shellcheck {} + || echo "  Shellcheck found issues"
    else
        echo "  No shell scripts found"
    fi
fi

# Markdown with markdownlint
if command -v markdownlint > /dev/null 2>&1; then
    echo ""
    echo "📄 Markdownlint (Markdown):"
    if find . -name "*.md" | head -1 | grep -q .; then
        markdownlint . || echo "  Markdownlint found issues"
    else
        echo "  No Markdown files found"
    fi
fi

echo ""
echo "✅ Code quality check complete!"
EOF

chmod +x /usr/local/bin/lint-all

# Create format script
cat > /usr/local/bin/format-all << 'EOF'
#!/bin/bash
# Format all code in the current directory

echo "🎨 Formatting Code..."
echo "===================="

# JavaScript/TypeScript/JSON/CSS with Prettier
if command -v prettier > /dev/null 2>&1; then
    echo ""
    echo "✨ Prettier (JS/TS/JSON/CSS/HTML/MD):"
    if find . \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" -o -name "*.json" -o -name "*.css" -o -name "*.scss" -o -name "*.html" -o -name "*.md" \) | head -1 | grep -q .; then
        prettier --write "**/*.{js,jsx,ts,tsx,json,css,scss,html,md}" || echo "  Prettier formatting failed"
    else
        echo "  No files to format with Prettier"
    fi
fi

# Python with Black
if command -v black > /dev/null 2>&1; then
    echo ""
    echo "⚫ Black (Python):"
    if find . -name "*.py" | head -1 | grep -q .; then
        black . || echo "  Black formatting failed"
    else
        echo "  No Python files found"
    fi
fi

echo ""
echo "✅ Code formatting complete!"
EOF

chmod +x /usr/local/bin/format-all

# Create pre-commit setup script
if [ "${INSTALLPRECOMMIT}" = "true" ] && command -v pre-commit > /dev/null 2>&1; then
    cat > /usr/local/bin/setup-precommit << 'EOF'
#!/bin/bash
# Set up pre-commit hooks for the current repository

echo "🪝 Setting up pre-commit hooks..."

if [ ! -f .pre-commit-config.yaml ]; then
    echo "Creating default .pre-commit-config.yaml..."
    cat > .pre-commit-config.yaml << 'PRECOMMIT_EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-json
      - id: check-toml
      - id: check-xml
      - id: check-merge-conflict
      - id: debug-statements
      - id: mixed-line-ending

  - repo: https://github.com/psf/black
    rev: 23.3.0
    hooks:
      - id: black
        language_version: python3

  - repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
      - id: flake8

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v3.0.0
    hooks:
      - id: prettier
        types_or: [javascript, jsx, ts, tsx, json, css, scss, html, markdown]

  - repo: https://github.com/koalaman/shellcheck-precommit
    rev: v0.9.0
    hooks:
      - id: shellcheck
PRECOMMIT_EOF
fi

# Install the hooks
pre-commit install
echo "✅ Pre-commit hooks installed! Run 'git commit' to see them in action."
EOF

    chmod +x /usr/local/bin/setup-precommit
fi

# Create code quality info command
cat > /usr/local/bin/quality-info << 'EOF'
#!/bin/sh
echo "🔧 Code Quality Tools Installed"
echo "==============================="
echo ""

echo "🔍 Linters:"
if command -v eslint > /dev/null 2>&1; then
    echo "  ✅ ESLint (JavaScript/TypeScript)"
fi
if command -v flake8 > /dev/null 2>&1; then
    echo "  ✅ Flake8 (Python)"
fi
if command -v shellcheck > /dev/null 2>&1; then
    echo "  ✅ Shellcheck (Shell scripts)"
fi
if command -v markdownlint > /dev/null 2>&1; then
    echo "  ✅ Markdownlint (Markdown)"
fi

echo ""
echo "🎨 Formatters:"
if command -v prettier > /dev/null 2>&1; then
    echo "  ✅ Prettier (JS/TS/JSON/CSS/HTML/MD)"
fi
if command -v black > /dev/null 2>&1; then
    echo "  ✅ Black (Python)"
fi

echo ""
echo "🪝 Git Hooks:"
if command -v pre-commit > /dev/null 2>&1; then
    echo "  ✅ Pre-commit framework"
fi

echo ""
echo "🛠️  Available Commands:"
echo "  lint-all         - Run all linters"
echo "  format-all       - Format all code"
if command -v pre-commit > /dev/null 2>&1; then
    echo "  setup-precommit  - Set up pre-commit hooks"
    echo "  pre-commit run --all-files  - Run pre-commit on all files"
fi

echo ""
echo "📁 Configuration Files:"
if [ -f "/workspace/.editorconfig" ]; then
    echo "  ✅ .editorconfig created"
fi
echo ""
echo "💡 Tips:"
echo "  - Run 'setup-precommit' in a git repository to enable automatic checks"
echo "  - Customize .pre-commit-config.yaml for your project needs"
echo "  - Use 'lint-all' and 'format-all' for quick code quality checks"
EOF

chmod +x /usr/local/bin/quality-info

echo "Code quality tools installed! Run 'quality-info' for details."