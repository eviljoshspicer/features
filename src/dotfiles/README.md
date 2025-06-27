# Personal Dotfiles

This feature allows you to clone and apply your personal dotfiles from a Git repository, making your development environment feel like home.

## Usage

```json
"features": {
    "ghcr.io/eviljoshspicer-features/dotfiles:1": {
        "repository": "https://github.com/username/dotfiles.git",
        "targetPath": "~/dotfiles",
        "installScript": "install.sh",
        "symlinkDotfiles": true,
        "backupExisting": true
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `repository` | string | `""` | Git repository URL containing your dotfiles |
| `targetPath` | string | `~/dotfiles` | Path where dotfiles repository will be cloned |
| `installScript` | string | `install.sh` | Name of the install script to run |
| `symlinkDotfiles` | boolean | `true` | Automatically symlink common dotfiles |
| `backupExisting` | boolean | `true` | Backup existing dotfiles before replacing |

## How It Works

1. **Clone Repository**: Clones your dotfiles repository to the specified path
2. **Run Install Script**: Executes your custom install script if it exists
3. **Auto-Symlink**: Automatically creates symlinks for common dotfiles (if enabled)
4. **Backup Protection**: Backs up existing files before replacing them (if enabled)

## Supported Repository Formats

- **HTTPS**: `https://github.com/username/dotfiles.git`
- **SSH**: `git@github.com:username/dotfiles.git` (requires SSH key setup)
- **Private repos**: Supported if authentication is configured

## Auto-Symlinked Files

When `symlinkDotfiles` is enabled, the following files are automatically symlinked:

### Configuration Files
- `.bashrc`, `.bash_profile`, `.bash_aliases`
- `.zshrc`, `.zsh_profile`
- `.profile`
- `.vimrc`
- `.tmux.conf`
- `.editorconfig`

### Git Configuration
- `.gitconfig`
- `.gitignore_global`

### Development Tools
- `.eslintrc`
- `.prettierrc`

### Directories
- `.ssh/` (SSH configuration)
- `.config/` (Application configurations)

## Custom Install Scripts

Your dotfiles repository can include a custom install script (default: `install.sh`) that will be executed after cloning. This is useful for:

- Installing additional packages
- Setting up complex configurations
- Running platform-specific setup
- Installing fonts or themes

Example install script:
```bash
#!/bin/bash
# install.sh

echo "Setting up custom dotfiles..."

# Install additional packages
sudo apt-get update
sudo apt-get install -y vim-gtk3

# Set up Vim plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Dotfiles setup complete!"
```

## Example Dotfiles Repository Structure

```
dotfiles/
├── install.sh          # Custom install script
├── .bashrc            # Bash configuration
├── .zshrc             # Zsh configuration  
├── .gitconfig         # Git configuration
├── .vimrc             # Vim configuration
├── .tmux.conf         # Tmux configuration
├── .config/           # Application configs
│   ├── nvim/
│   └── git/
└── .ssh/
    └── config         # SSH configuration
```

## Tips

1. **Keep it simple**: Start with basic configurations and add complexity gradually
2. **Use branches**: Keep different configurations for different environments
3. **Document**: Include a README in your dotfiles repository
4. **Test**: Test your dotfiles in a clean environment before deploying

Run `dotfiles-info` in your container to see the status of your dotfiles installation.