#!/bin/sh
set -e

echo "Activating feature 'ascii-art'"
echo "The provided style is: ${STYLE}"
echo "The default text is: ${DEFAULTTEXT}"

# Install figlet for ASCII art generation
apt-get update && apt-get install -y figlet

# Create ascii-banner command
cat > /usr/local/bin/ascii-banner \
<< EOF
#!/bin/sh

STYLE=\${STYLE:-${STYLE}}
DEFAULT_TEXT="\${DEFAULT_TEXT:-${DEFAULTTEXT}}"
TEXT="\${1:-\$DEFAULT_TEXT}"

case \$STYLE in
    "slant")
        figlet -f slant "\$TEXT"
        ;;
    "big")
        figlet -f big "\$TEXT"
        ;;
    "block")
        figlet -f block "\$TEXT"
        ;;
    "bubble")
        figlet -f bubble "\$TEXT"
        ;;
    *)
        figlet "\$TEXT"
        ;;
esac
EOF

chmod +x /usr/local/bin/ascii-banner

# Create a colorful welcome script
cat > /usr/local/bin/welcome-banner \
<< EOF
#!/bin/sh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

TEXT="\${1:-Welcome}"

echo "\${CYAN}"
ascii-banner "\$TEXT"
echo "\${NC}"
echo "\${GREEN}🚀 Development environment ready!\${NC}"
echo "\${YELLOW}💡 Use 'ascii-banner <text>' to create custom banners\${NC}"
EOF

chmod +x /usr/local/bin/welcome-banner

echo "ASCII Art feature installed! Use 'ascii-banner <text>' or 'welcome-banner <text>' commands."