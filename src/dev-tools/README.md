# Essential Dev Tools

This feature installs a curated collection of essential development tools and utilities to boost your productivity.

## Usage

After installation, you'll have access to powerful command-line tools:

```bash
# JSON processing
echo '{"name": "test"}' | jq '.name'

# Better file viewing
bat README.md           # Syntax highlighted cat
tree src/              # Directory structure
fd "*.json"            # Fast file search
rg "function"          # Fast text search

# Network tools
http GET api.github.com/users/octocat
curl -s api.github.com/repos/microsoft/vscode | jq '.name'

# System monitoring
htop                   # Interactive process viewer
ncdu                   # Disk usage analyzer
```

See all installed tools:
```bash
dev-tools-info
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| includeJsonTools | Install JSON processing tools | boolean | true |
| includeNetworkTools | Install network tools | boolean | true |
| includeFileTools | Install file tools | boolean | true |
| includeSystemTools | Install system monitoring tools | boolean | true |

## Included Tools

### JSON Tools (includeJsonTools=true)
- **jq** - Command-line JSON processor
- **fx** - Interactive JSON viewer (if npm available)

### Network Tools (includeNetworkTools=true)  
- **curl** - Transfer data to/from servers
- **wget** - Download files from web
- **httpie** - User-friendly curl alternative

### File Tools (includeFileTools=true)
- **tree** - Display directory structure
- **bat** - Better cat with syntax highlighting
- **fd** - Fast and user-friendly find alternative
- **ripgrep (rg)** - Fast text search tool

### System Tools (includeSystemTools=true)
- **htop** - Interactive process viewer
- **ncdu** - Disk usage analyzer

## Examples

```jsonc
"features": {
    "ghcr.io/eviljoshspicer/eviljoshspicer-features/dev-tools:1": {
        "includeJsonTools": true,
        "includeNetworkTools": true,
        "includeFileTools": true,
        "includeSystemTools": false
    }
}
```

Perfect for setting up a productive development environment with all the essential tools!