# Terminal Themes & Prompts

This feature installs beautiful terminal themes, prompts, and customizations to enhance your terminal experience.

## Usage

```json
"features": {
    "ghcr.io/eviljoshspicer-features/terminal-themes:1": {
        "installStarship": true,
        "installOhMyZsh": true,
        "ohMyZshTheme": "agnoster",
        "installPowerlineFonts": true,
        "installNeofetch": true,
        "autoStartNeofetch": false
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `installStarship` | boolean | `true` | Install Starship cross-shell prompt |
| `installOhMyZsh` | boolean | `true` | Install Oh My Zsh framework |
| `ohMyZshTheme` | string | `robbyrussell` | Oh My Zsh theme to use |
| `installPowerlineFonts` | boolean | `true` | Install Powerline fonts |
| `installNeofetch` | boolean | `true` | Install neofetch system info tool |
| `autoStartNeofetch` | boolean | `false` | Auto-run neofetch on shell startup |

## Installed Components

### Starship Prompt
- 🚀 Modern, fast, and customizable prompt
- Works with bash, zsh, fish, and more
- Rich git integration and status indicators
- Configurable via `~/.config/starship.toml`

### Oh My Zsh
- 🐚 Popular zsh framework
- Hundreds of themes and plugins
- Easy customization and extension
- Auto-completion and aliases

### Popular Themes
- `robbyrussell` (default) - Clean and simple
- `agnoster` - Powerline-style with git info  
- `powerlevel10k` - Fast and feature-rich
- `spaceship` - Minimalist with git/docker info

### Powerline Fonts
- ⚡ Enhanced fonts with special characters
- Better symbol rendering in terminals
- Supports theme icons and separators

### Neofetch
- 🖥️ Beautiful system information display
- Shows OS, kernel, uptime, and hardware
- Customizable ASCII art and colors

## Quick Start

1. **Set zsh as default shell** (optional):
   ```bash
   chsh -s $(which zsh)
   ```

2. **Customize Starship prompt**:
   ```bash
   nano ~/.config/starship.toml
   ```

3. **Change Oh My Zsh theme**:
   ```bash
   nano ~/.zshrc
   # Edit ZSH_THEME="theme-name"
   ```

4. **View system info**:
   ```bash
   neofetch
   ```

## Available Commands

- `themes-info` - Show installed themes and configuration
- `starship config` - Edit Starship configuration  
- `neofetch` - Display system information

## Popular Theme Combinations

### Developer Setup
```json
{
    "installStarship": true,
    "installOhMyZsh": true,
    "ohMyZshTheme": "agnoster",
    "installPowerlineFonts": true
}
```

### Minimal Setup
```json
{
    "installStarship": true,
    "installOhMyZsh": false,
    "installNeofetch": false
}
```

### Full Experience
```json
{
    "installStarship": true,
    "installOhMyZsh": true,
    "ohMyZshTheme": "powerlevel10k",
    "installPowerlineFonts": true,
    "installNeofetch": true,
    "autoStartNeofetch": true
}
```

Run `themes-info` in your container to see what's installed and get customization tips!