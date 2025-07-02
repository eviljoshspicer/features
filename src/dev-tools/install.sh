#!/bin/sh
set -e

echo "Activating feature 'dev-tools'"
echo "Include JSON tools: ${INCLUDEJSONTOOLS}"
echo "Include network tools: ${INCLUDENETWORKTOOLS}" 
echo "Include file tools: ${INCLUDEFILETOOLS}"
echo "Include system tools: ${INCLUDESYSTEMTOOLS}"

# Update package list
apt-get update

# JSON processing tools
if [ "${INCLUDEJSONTOOLS}" = "true" ]; then
    echo "Installing JSON tools..."
    apt-get install -y jq
    
    # Install fx (interactive JSON viewer) via npm if available
    if command -v npm >/dev/null 2>&1; then
        npm install -g fx
    fi
fi

# Network tools  
if [ "${INCLUDENETWORKTOOLS}" = "true" ]; then
    echo "Installing network tools..."
    apt-get install -y curl wget
    
    # Install httpie
    apt-get install -y python3-pip
    pip3 install httpie
fi

# File tools
if [ "${INCLUDEFILETOOLS}" = "true" ]; then
    echo "Installing file tools..."
    apt-get install -y tree
    
    # Install bat (better cat)
    apt-get install -y bat || true
    
    # Install fd-find (better find)
    apt-get install -y fd-find || true
    
    # Install ripgrep (better grep)
    apt-get install -y ripgrep || true
    
    # Create symbolic links for easier access
    if [ -f /usr/bin/batcat ]; then
        ln -sf /usr/bin/batcat /usr/local/bin/bat
    fi
    
    if [ -f /usr/bin/fdfind ]; then
        ln -sf /usr/bin/fdfind /usr/local/bin/fd
    fi
fi

# System monitoring tools
if [ "${INCLUDESYSTEMTOOLS}" = "true" ]; then
    echo "Installing system tools..."
    apt-get install -y htop ncdu
fi

# Create a tools info command
cat > /usr/local/bin/dev-tools-info \
<< 'EOF'
#!/bin/sh

echo "🛠️  Essential Dev Tools Installed:"
echo "=================================="
echo ""

if command -v jq >/dev/null 2>&1; then
    echo "📄 JSON Tools:"
    echo "  jq          - Command-line JSON processor"
    if command -v fx >/dev/null 2>&1; then
        echo "  fx          - Interactive JSON viewer"
    fi
    echo ""
fi

if command -v curl >/dev/null 2>&1; then
    echo "🌐 Network Tools:"
    echo "  curl        - Transfer data to/from servers"
    echo "  wget        - Download files from web"
    if command -v http >/dev/null 2>&1; then
        echo "  http        - HTTPie - user-friendly curl"
    fi
    echo ""
fi

if command -v tree >/dev/null 2>&1; then
    echo "📁 File Tools:"
    echo "  tree        - Display directory tree structure"
    if command -v bat >/dev/null 2>&1; then
        echo "  bat         - Better cat with syntax highlighting"
    fi
    if command -v fd >/dev/null 2>&1; then
        echo "  fd          - Better find command"
    fi
    if command -v rg >/dev/null 2>&1; then
        echo "  rg          - Ripgrep - fast text search"
    fi
    echo ""
fi

if command -v htop >/dev/null 2>&1; then
    echo "⚡ System Tools:"
    echo "  htop        - Interactive process viewer"
    if command -v ncdu >/dev/null 2>&1; then
        echo "  ncdu        - Disk usage analyzer"
    fi
    echo ""
fi

echo "💡 Use these tools to boost your development productivity!"
EOF

chmod +x /usr/local/bin/dev-tools-info

# Clean up
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Development tools installed! Use 'dev-tools-info' to see what's available."