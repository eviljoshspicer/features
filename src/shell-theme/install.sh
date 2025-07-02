#!/bin/sh
set -e

echo "Activating feature 'shell-theme'"
echo "Theme: ${THEME}"
echo "Show git info: ${SHOWGITINFO}"
echo "Show time: ${SHOWTIME}"

# Create the shell theme configuration
cat > /usr/local/bin/setup-shell-theme \
<< 'EOF'
#!/bin/bash

THEME=${THEME:-git-focused}
SHOW_GIT=${SHOWGITINFO:-true}
SHOW_TIME=${SHOWTIME:-false}

# Color definitions
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[0;33m\]'
BLUE='\[\033[0;34m\]'
PURPLE='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
WHITE='\[\033[0;37m\]'
BOLD='\[\033[1m\]'
RESET='\[\033[0m\]'

# Git info function
git_info() {
    if [ "$SHOW_GIT" = "true" ] && git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
        local status=""
        
        # Check for changes
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
            status="${RED}●${RESET}"
        else
            status="${GREEN}●${RESET}"
        fi
        
        echo " ${CYAN}(${branch}${status}${CYAN})${RESET}"
    fi
}

# Time function
time_info() {
    if [ "$SHOW_TIME" = "true" ]; then
        echo "${YELLOW}[\$(date +%H:%M:%S)]${RESET} "
    fi
}

# Set prompt based on theme
case $THEME in
    "minimal")
        PS1="${GREEN}\u${RESET} ${BLUE}\W${RESET}\$(git_info) ${WHITE}$ ${RESET}"
        ;;
    "powerline")
        PS1="\$(time_info)${BOLD}${BLUE}\u${RESET}${WHITE}@${RESET}${BOLD}${GREEN}\h${RESET} ${PURPLE}\w${RESET}\$(git_info)\n${WHITE}❯ ${RESET}"
        ;;
    "git-focused")
        PS1="${GREEN}\u${RESET}${WHITE}:${RESET}${BLUE}\w${RESET}\$(git_info) ${WHITE}$ ${RESET}"
        ;;
    "full")
        PS1="\$(time_info)${BOLD}${GREEN}\u${RESET}${WHITE}@${RESET}${BOLD}${CYAN}\h${RESET} ${PURPLE}\w${RESET}\$(git_info)\n${YELLOW}❯${RESET} "
        ;;
esac

# Export the PS1
export PS1

# Also set for interactive shells
echo "export PS1='$PS1'" >> ~/.bashrc
EOF

chmod +x /usr/local/bin/setup-shell-theme

# Function to setup theme for a specific user
setup_for_user() {
    local user=$1
    local home_dir=$2
    
    if [ -n "$user" ] && [ -d "$home_dir" ]; then
        # Create theme setup in user's bashrc
        cat >> "$home_dir/.bashrc" << 'EOF'

# Enhanced Shell Theme
if [ -f /usr/local/bin/setup-shell-theme ]; then
    source /usr/local/bin/setup-shell-theme
fi
EOF
        
        # Set ownership
        chown "$user:$user" "$home_dir/.bashrc" 2>/dev/null || true
    fi
}

# Setup for root
setup_for_user "root" "/root"

# Setup for remote user
if [ -n "$_REMOTE_USER" ] && [ "$_REMOTE_USER" != "root" ]; then
    setup_for_user "$_REMOTE_USER" "$_REMOTE_USER_HOME"
fi

# Setup for container user  
if [ -n "$_CONTAINER_USER" ] && [ "$_CONTAINER_USER" != "root" ] && [ "$_CONTAINER_USER" != "$_REMOTE_USER" ]; then
    setup_for_user "$_CONTAINER_USER" "$_CONTAINER_USER_HOME"
fi

# Create a theme switcher command
cat > /usr/local/bin/switch-theme \
<< 'EOF'
#!/bin/bash

AVAILABLE_THEMES=("minimal" "powerline" "git-focused" "full")

if [ $# -eq 0 ]; then
    echo "Available themes:"
    for theme in "${AVAILABLE_THEMES[@]}"; do
        echo "  - $theme"
    done
    echo ""
    echo "Usage: switch-theme <theme-name>"
    echo "Example: switch-theme powerline"
    exit 0
fi

NEW_THEME=$1

# Validate theme
if [[ ! " ${AVAILABLE_THEMES[@]} " =~ " ${NEW_THEME} " ]]; then
    echo "Invalid theme: $NEW_THEME"
    echo "Available themes: ${AVAILABLE_THEMES[*]}"
    exit 1
fi

# Update environment variables
export THEME=$NEW_THEME

# Reload the theme
source /usr/local/bin/setup-shell-theme

echo "Theme switched to: $NEW_THEME"
echo "Restart your shell or run 'source ~/.bashrc' to see changes"
EOF

chmod +x /usr/local/bin/switch-theme

echo "Shell theme installed! Current theme: ${THEME}"
echo "Use 'switch-theme' to change themes dynamically."