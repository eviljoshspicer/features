# Shell Enhancements

This feature adds useful shell aliases, functions, and productivity enhancements to make your terminal experience more efficient.

## Usage

```json
"features": {
    "ghcr.io/eviljoshspicer-features/shell-enhancements:1": {
        "includeColorOutput": true,
        "includeDirectoryAliases": true, 
        "includeDockerAliases": true,
        "shell": "both"
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `includeColorOutput` | boolean | `true` | Enable colorized output for ls, grep, and other commands |
| `includeDirectoryAliases` | boolean | `true` | Include directory navigation shortcuts |
| `includeDockerAliases` | boolean | `true` | Include Docker and Docker Compose shortcuts |
| `shell` | string | `both` | Which shell to configure (`bash`, `zsh`, or `both`) |

## Installed Features

### Safety & Better Defaults
- `rm`, `cp`, `mv` - Interactive mode by default
- `ll`, `la`, `l` - Enhanced ls variations
- `..`, `...`, `....` - Navigate up directories
- `df`, `du`, `free` - Human readable output

### File Operations
- `ff <name>` - Find files by name
- `fd <name>` - Find directories by name  
- `extract <file>` - Extract various archive formats
- `backup <file>` - Create .bak copy of file
- `mkcd <dir>` - Make directory and cd into it

### Development Tools
- `serve` - Start Python HTTP server on port 8000
- `jsonpp` - Pretty print JSON
- `urlencode/urldecode` - URL encoding utilities
- `weather [city]` - Get weather info (requires curl)

### Git Shortcuts (if git available)
- `g`, `gs`, `gd`, `ga`, `gc`, `gp`, `gl` - Common git commands

### Docker Shortcuts (if docker available)
- `d`, `dc` - docker and docker-compose
- `dps`, `di` - docker ps and images
- `dex`, `dlogs` - exec and logs
- `dcup`, `dcdown` - compose up/down

### Directory Navigation (when enabled)
- `desk`, `docs`, `downloads` - Quick navigation
- `projects`, `workspace` - Common dev directories

Run `shell-help` in your container to see all available enhancements.