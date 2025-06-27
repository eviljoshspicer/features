#!/bin/sh
set -e

echo "Activating feature 'dotfiles'"

# Check if repository URL is provided
if [ -z "${REPOSITORY}" ]; then
    echo "No dotfiles repository specified. Skipping dotfiles installation."
    exit 0
fi

echo "Dotfiles repository: ${REPOSITORY}"
echo "Target path: ${TARGETPATH}"
echo "Install script: ${INSTALLSCRIPT}"

# Expand ~ in target path
EXPANDED_TARGET_PATH=$(eval echo "${TARGETPATH}")

# Function to backup existing files
backup_file() {
    local file="$1"
    if [ -f "$file" ] || [ -L "$file" ]; then
        if [ "${BACKUPEXISTING}" = "true" ]; then
            echo "Backing up existing $file to $file.backup"
            cp "$file" "$file.backup" 2>/dev/null || true
        fi
    fi
}

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -f "$source" ]; then
        backup_file "$target"
        rm -f "$target"
        ln -sf "$source" "$target"
        echo "Linked $source -> $target"
    fi
}

# Clone the dotfiles repository
echo "Cloning dotfiles repository..."
if [ -d "$EXPANDED_TARGET_PATH" ]; then
    echo "Target directory already exists. Pulling latest changes..."
    cd "$EXPANDED_TARGET_PATH"
    git pull || echo "Failed to pull changes, continuing with existing files..."
else
    git clone "$REPOSITORY" "$EXPANDED_TARGET_PATH"
    cd "$EXPANDED_TARGET_PATH"
fi

# Make the target directory owned by the remote user if we know who that is
if [ -n "$_REMOTE_USER" ] && [ "$_REMOTE_USER" != "root" ]; then
    chown -R "$_REMOTE_USER:$_REMOTE_USER" "$EXPANDED_TARGET_PATH"
fi

# Run custom install script if it exists
INSTALL_SCRIPT_PATH="$EXPANDED_TARGET_PATH/${INSTALLSCRIPT}"
if [ -f "$INSTALL_SCRIPT_PATH" ]; then
    echo "Running custom install script: ${INSTALLSCRIPT}"
    chmod +x "$INSTALL_SCRIPT_PATH"
    cd "$EXPANDED_TARGET_PATH"
    
    # Run as remote user if possible, otherwise as root
    if [ -n "$_REMOTE_USER" ] && [ "$_REMOTE_USER" != "root" ]; then
        su "$_REMOTE_USER" -c "cd '$EXPANDED_TARGET_PATH' && ./${INSTALLSCRIPT}"
    else
        "./${INSTALLSCRIPT}"
    fi
else
    echo "No custom install script found (${INSTALLSCRIPT})"
fi

# Auto-symlink common dotfiles if enabled
if [ "${SYMLINKDOTFILES}" = "true" ]; then
    echo "Auto-symlinking common dotfiles..."
    
    # Determine home directory
    if [ -n "$_REMOTE_USER_HOME" ]; then
        HOME_DIR="$_REMOTE_USER_HOME"
    elif [ -n "$_REMOTE_USER" ] && [ "$_REMOTE_USER" != "root" ]; then
        HOME_DIR="/home/$_REMOTE_USER"
    else
        HOME_DIR="/root"
    fi
    
    echo "Using home directory: $HOME_DIR"
    
    # Common dotfiles to symlink
    DOTFILES="
        .bashrc
        .bash_profile
        .bash_aliases
        .zshrc
        .zsh_profile
        .gitconfig
        .gitignore_global
        .vimrc
        .tmux.conf
        .editorconfig
        .eslintrc
        .prettierrc
        .profile
    "
    
    for dotfile in $DOTFILES; do
        source_file="$EXPANDED_TARGET_PATH/$dotfile"
        target_file="$HOME_DIR/$dotfile"
        
        if [ -f "$source_file" ]; then
            create_symlink "$source_file" "$target_file"
            
            # Change ownership to remote user if needed
            if [ -n "$_REMOTE_USER" ] && [ "$_REMOTE_USER" != "root" ]; then
                chown -h "$_REMOTE_USER:$_REMOTE_USER" "$target_file" 2>/dev/null || true
            fi
        fi
    done
    
    # Handle directories
    DOTDIRS="
        .ssh
        .config
    "
    
    for dotdir in $DOTDIRS; do
        source_dir="$EXPANDED_TARGET_PATH/$dotdir"
        target_dir="$HOME_DIR/$dotdir"
        
        if [ -d "$source_dir" ]; then
            if [ -d "$target_dir" ] && [ "${BACKUPEXISTING}" = "true" ]; then
                echo "Backing up existing $target_dir to $target_dir.backup"
                cp -r "$target_dir" "$target_dir.backup" 2>/dev/null || true
            fi
            
            rm -rf "$target_dir"
            ln -sf "$source_dir" "$target_dir"
            echo "Linked $source_dir -> $target_dir"
            
            # Change ownership to remote user if needed
            if [ -n "$_REMOTE_USER" ] && [ "$_REMOTE_USER" != "root" ]; then
                chown -h "$_REMOTE_USER:$_REMOTE_USER" "$target_dir" 2>/dev/null || true
            fi
        fi
    done
fi

# Create dotfiles info command
cat > /usr/local/bin/dotfiles-info << EOF
#!/bin/sh
echo "📁 Personal Dotfiles Information"
echo "==============================="
echo ""
echo "Repository: ${REPOSITORY}"
echo "Cloned to: ${EXPANDED_TARGET_PATH}"
echo "Install script: ${INSTALLSCRIPT}"
echo "Auto-symlink enabled: ${SYMLINKDOTFILES}"
echo "Backup existing: ${BACKUPEXISTING}"
echo ""

if [ -d "${EXPANDED_TARGET_PATH}" ]; then
    echo "📦 Repository Status:"
    cd "${EXPANDED_TARGET_PATH}"
    git log -1 --pretty=format:"  Last commit: %h - %s (%cr)" 2>/dev/null || echo "  Unable to get git status"
    echo ""
    echo ""
    
    echo "🔗 Symlinked Files:"
    find "\${HOME}" -maxdepth 1 -type l -ls 2>/dev/null | grep "${EXPANDED_TARGET_PATH}" | while read -r line; do
        echo "  \$line"
    done
else
    echo "❌ Dotfiles directory not found"
fi
EOF

chmod +x /usr/local/bin/dotfiles-info

echo "Dotfiles setup complete! Run 'dotfiles-info' for details."