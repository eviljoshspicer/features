#!/bin/sh
set -e

echo "Activating feature 'terminal-themes'"

# Update package lists
apt-get update

# Install required packages
apt-get install -y curl wget git fontconfig

# Install Starship if enabled
if [ "${INSTALLSTARSHIP}" = "true" ]; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    
    # Create default starship config
    mkdir -p /etc/skel/.config
    cat > /etc/skel/.config/starship.toml << 'EOF'
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[git_branch]
symbol = "🌱 "

[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"

[nodejs]
symbol = "⬢ "

[python]
symbol = "🐍 "

[rust]
symbol = "🦀 "

[package]
symbol = "📦 "
EOF
    
    # Copy to current user directories
    if [ -n "$_REMOTE_USER_HOME" ] && [ "$_REMOTE_USER" != "root" ]; then
        mkdir -p "$_REMOTE_USER_HOME/.config"
        cp /etc/skel/.config/starship.toml "$_REMOTE_USER_HOME/.config/"
        chown -R "$_REMOTE_USER:$_REMOTE_USER" "$_REMOTE_USER_HOME/.config"
    fi
    
    # Add to shell configs
    echo 'eval "$(starship init bash)"' >> /etc/bash.bashrc
    echo 'eval "$(starship init zsh)"' >> /etc/zsh/zshrc 2>/dev/null || true
fi

# Install Oh My Zsh if enabled
if [ "${INSTALLZSH}" = "true" ] || [ "${INSTALLOHMYZSH}" = "true" ]; then
    echo "Installing zsh and Oh My Zsh..."
    
    # Install zsh if not present
    apt-get install -y zsh
    
    # Install Oh My Zsh for the remote user
    if [ -n "$_REMOTE_USER" ] && [ "$_REMOTE_USER" != "root" ]; then
        echo "Installing Oh My Zsh for user: $_REMOTE_USER"
        su "$_REMOTE_USER" -c 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended'
        
        # Set the theme
        if [ -n "${OHMYZSHTHEME}" ]; then
            su "$_REMOTE_USER" -c "sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"${OHMYZSHTHEME}\"/' ~/.zshrc"
        fi
        
        # Add some popular plugins
        su "$_REMOTE_USER" -c "sed -i 's/plugins=(git)/plugins=(git docker docker-compose node npm python pip)/' ~/.zshrc"
    fi
    
    # Also install for root
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended || true
    if [ -n "${OHMYZSHTHEME}" ]; then
        sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"${OHMYZSHTHEME}\"/" ~/.zshrc 2>/dev/null || true
    fi
fi

# Install Powerline fonts if enabled
if [ "${INSTALLPOWERLINEFONTS}" = "true" ]; then
    echo "Installing Powerline fonts..."
    
    # Create fonts directory
    mkdir -p /usr/local/share/fonts/powerline
    
    # Download and install popular powerline fonts
    cd /tmp
    git clone https://github.com/powerline/fonts.git powerline-fonts
    cd powerline-fonts
    ./install.sh
    cd ..
    rm -rf powerline-fonts
    
    # Update font cache
    fc-cache -f -v
fi

# Install neofetch if enabled
if [ "${INSTALLNEOFETCH}" = "true" ]; then
    echo "Installing neofetch..."
    apt-get install -y neofetch
    
    # Create custom neofetch config
    mkdir -p /etc/skel/.config/neofetch
    cat > /etc/skel/.config/neofetch/config.conf << 'EOF'
print_info() {
    info title
    info underline

    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "Resolution" resolution
    info "DE" de
    info "WM" wm
    info "WM Theme" wm_theme
    info "Theme" theme
    info "Icons" icons
    info "Terminal" term
    info "Terminal Font" term_font
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory

    info "CPU Usage" cpu_usage
    info "Disk" disk
    info "Battery" battery
    info "Font" font
    info "Song" song
    info "Local IP" local_ip
    info "Public IP" public_ip
    info "Users" users
    info "Locale" locale

    info cols
}

# Hide/Show Fully qualified domain name.
title_fqdn="off"

# Shorten the output of the kernel function.
kernel_shorthand="on"

# Shorten the output of the distro function
distro_shorthand="off"

# Show/Hide OS Architecture.
os_arch="on"

# Shorten the output of the uptime function
uptime_shorthand="on"

# Show memory pecentage in output.
memory_percent="on"

# Change memory output unit.
memory_unit="gib"

# Show/Hide Package Manager names.
package_managers="on"

# Show the path to $SHELL
shell_path="off"

# Show $SHELL version
shell_version="on"

# CPU speed type
speed_type="bios_limit"

# CPU speed shorthand
speed_shorthand="on"

# Enable/Disable CPU brand in output.
cpu_brand="on"

# CPU Speed
cpu_speed="on"

# CPU Cores
cpu_cores="logical"

# CPU Temperature
cpu_temp="off"

# Enable/Disable GPU Brand
gpu_brand="on"

# Which GPU to display
gpu_type="all"

# Display refresh rate next to each monitor
refresh_rate="off"

# Shorten output of GTK Theme / Icons / Font
gtk_shorthand="off"

# Enable/Disable gtk2 Theme / Icons / Font
gtk2="on"

# Enable/Disable gtk3 Theme / Icons / Font
gtk3="on"

# Website to ping for the public IP
public_ip_host="http://ident.me"

# Public IP timeout.
public_ip_timeout=2

# Desktop Environment
de_version="on"

# Disk subtitle
disk_subtitle="mount"

# Disk percent.
disk_percent="on"

# Manually specify a music player.
music_player="auto"

# Format to display song information.
song_format="%artist% - %album% - %title%"

# Print the Artist, Album and Title on separate lines
song_shorthand="off"

# 'mpc' arguments (specify a host, password etc).
mpc_args=()

# Text Colors
colors=(distro)

# Text Options
bold="on"
underline_enabled="on"
underline_char="-"
separator=":"

# Color Blocks
block_range=(0 15)
color_blocks="on"
block_width=3
block_height=1
col_offset="auto"

# Progress Bars
bar_char_elapsed="-"
bar_char_total="="
bar_border="on"
bar_length=15
bar_color_elapsed="distro"
bar_color_total="distro"
cpu_display="off"
memory_display="off"
battery_display="off"
disk_display="off"

# Backend Settings
image_backend="ascii"
image_source="auto"

# Ascii Options
ascii_distro="auto"
ascii_colors=(distro)
ascii_bold="on"

# Image Options
image_loop="off"
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"
crop_mode="normal"
crop_offset="center"
image_size="auto"
gap=3
yoffset=0
xoffset=0
background_color=

# Misc Options
stdout="off"
EOF

    # Copy to user directories
    if [ -n "$_REMOTE_USER_HOME" ] && [ "$_REMOTE_USER" != "root" ]; then
        mkdir -p "$_REMOTE_USER_HOME/.config/neofetch"
        cp /etc/skel/.config/neofetch/config.conf "$_REMOTE_USER_HOME/.config/neofetch/"
        chown -R "$_REMOTE_USER:$_REMOTE_USER" "$_REMOTE_USER_HOME/.config"
    fi
    
    # Auto-start neofetch if enabled
    if [ "${AUTOSTARTNEOFETCH}" = "true" ]; then
        echo "neofetch" >> /etc/bash.bashrc
        echo "neofetch" >> /etc/zsh/zshrc 2>/dev/null || true
    fi
fi

# Create terminal themes info command
cat > /usr/local/bin/themes-info << 'EOF'
#!/bin/sh
echo "🎨 Terminal Themes & Customizations"
echo "==================================="
echo ""

if command -v starship > /dev/null 2>&1; then
    echo "✨ Starship: $(starship --version)"
    echo "   Config: ~/.config/starship.toml"
fi

if [ -d ~/.oh-my-zsh ]; then
    echo "🐚 Oh My Zsh: Installed"
    if [ -f ~/.zshrc ]; then
        theme=$(grep "ZSH_THEME=" ~/.zshrc | cut -d'"' -f2)
        echo "   Theme: $theme"
    fi
fi

if command -v neofetch > /dev/null 2>&1; then
    echo "🖥️  Neofetch: $(neofetch --version | head -n1)"
fi

if fc-list | grep -q "Powerline" 2>/dev/null; then
    echo "⚡ Powerline Fonts: Installed"
fi

echo ""
echo "🛠️  Available Commands:"
echo "  neofetch      - Show system information"
echo "  starship      - Starship prompt commands"
echo ""
echo "💡 Tips:"
echo "  - Edit ~/.config/starship.toml to customize Starship"
echo "  - Run 'chsh -s $(which zsh)' to set zsh as default shell"
echo "  - Restart your terminal to see theme changes"
EOF

chmod +x /usr/local/bin/themes-info

echo "Terminal themes installed! Run 'themes-info' for details."