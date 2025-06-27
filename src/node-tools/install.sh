#!/bin/sh
set -e

echo "Activating feature 'node-tools'"

# Ensure Node.js is available
if ! command -v node > /dev/null 2>&1; then
    echo "Warning: Node.js not found. Please ensure the Node.js feature is installed first."
    exit 1
fi

# Ensure npm is available
if ! command -v npm > /dev/null 2>&1; then
    echo "Warning: npm not found. Please ensure the Node.js feature is installed first."
    exit 1
fi

echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Install pnpm if requested
if [ "${INSTALLPNPM}" = "true" ]; then
    echo "Installing pnpm..."
    if [ "${PNPMVERSION}" = "latest" ]; then
        npm install -g pnpm
    else
        npm install -g "pnpm@${PNPMVERSION}"
    fi
    echo "pnpm installed: $(pnpm --version)"
fi

# Install Yarn if requested  
if [ "${INSTALLYARN}" = "true" ]; then
    echo "Installing Yarn..."
    if [ "${YARNVERSION}" = "stable" ]; then
        npm install -g yarn
    else
        npm install -g "yarn@${YARNVERSION}"
    fi
    echo "Yarn installed: $(yarn --version)"
fi

# Install global development tools if requested
if [ "${INSTALLGLOBALTOOLS}" = "true" ]; then
    echo "Installing global Node.js development tools..."
    
    # Essential development tools
    npm install -g \
        nodemon \
        serve \
        http-server \
        json-server \
        live-server \
        concurrently \
        cross-env \
        rimraf \
        npm-check-updates \
        pm2 \
        typescript \
        ts-node \
        @types/node
    
    echo "Global tools installed successfully!"
fi

# Create package manager shortcuts
cat > /usr/local/bin/pm << 'EOF'
#!/bin/sh
# Smart package manager - detects and uses the appropriate package manager

detect_pm() {
    if [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "yarn.lock" ]; then
        echo "yarn"
    elif [ -f "package-lock.json" ]; then
        echo "npm"
    else
        # Default preference order
        if command -v pnpm > /dev/null 2>&1; then
            echo "pnpm"
        elif command -v yarn > /dev/null 2>&1; then
            echo "yarn"
        else
            echo "npm"
        fi
    fi
}

PM=$(detect_pm)
echo "Using package manager: $PM"

case "$1" in
    "install"|"i")
        $PM install "${@:2}"
        ;;
    "add"|"a")
        case $PM in
            "npm") npm install "${@:2}" ;;
            *) $PM add "${@:2}" ;;
        esac
        ;;
    "dev"|"add-dev"|"d")
        case $PM in
            "npm") npm install --save-dev "${@:2}" ;;
            "yarn") yarn add --dev "${@:2}" ;;
            "pnpm") pnpm add --save-dev "${@:2}" ;;
        esac
        ;;
    "remove"|"rm"|"r")
        case $PM in
            "npm") npm uninstall "${@:2}" ;;
            "yarn") yarn remove "${@:2}" ;;
            "pnpm") pnpm remove "${@:2}" ;;
        esac
        ;;
    "run"|"start"|"build"|"test")
        $PM run "$@"
        ;;
    "exec"|"x")
        case $PM in
            "npm") npx "${@:2}" ;;
            *) $PM exec "${@:2}" ;;
        esac
        ;;
    *)
        $PM "$@"
        ;;
esac
EOF

chmod +x /usr/local/bin/pm

# Create Node.js development info command
cat > /usr/local/bin/node-info << 'EOF'
#!/bin/sh
echo "🚀 Node.js Development Environment"
echo "=================================="
echo ""

if command -v node > /dev/null 2>&1; then
    echo "📦 Node.js: $(node --version)"
fi

if command -v npm > /dev/null 2>&1; then
    echo "📦 npm: $(npm --version)"
fi

if command -v yarn > /dev/null 2>&1; then
    echo "📦 Yarn: $(yarn --version)"
fi

if command -v pnpm > /dev/null 2>&1; then
    echo "📦 pnpm: $(pnpm --version)"
fi

echo ""
echo "🛠️  Available Global Tools:"
for tool in nodemon serve http-server json-server live-server concurrently cross-env rimraf npm-check-updates pm2 typescript ts-node; do
    if command -v "$tool" > /dev/null 2>&1; then
        echo "  ✅ $tool"
    fi
done

echo ""
echo "🎯 Smart Package Manager:"
echo "  Use 'pm' command to auto-detect and use the right package manager"
echo "  Examples:"
echo "    pm install    - Install dependencies"
echo "    pm add <pkg>  - Add package"
echo "    pm dev <pkg>  - Add dev dependency"
echo "    pm run <cmd>  - Run script"
echo "    pm exec <cmd> - Execute command"
EOF

chmod +x /usr/local/bin/node-info

echo "Node.js development tools installed! Run 'node-info' to see what's available."