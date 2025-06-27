# Node.js Development Tools

This feature installs popular Node.js development tools and package managers to enhance your development workflow.

## Usage

```json
"features": {
    "ghcr.io/eviljoshspicer-features/node-tools:1": {
        "installPnpm": true,
        "installYarn": true,
        "installGlobalTools": true,
        "pnpmVersion": "latest",
        "yarnVersion": "stable"
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `installPnpm` | boolean | `true` | Install pnpm package manager |
| `installYarn` | boolean | `true` | Install Yarn package manager |
| `installGlobalTools` | boolean | `true` | Install common global Node.js tools |
| `pnpmVersion` | string | `latest` | Version of pnpm to install |
| `yarnVersion` | string | `stable` | Version of Yarn to install |

## Package Managers Installed

- **npm** - Comes with Node.js
- **pnpm** - Fast, disk space efficient package manager
- **yarn** - Popular alternative package manager

## Global Tools Installed (when enabled)

### Development Servers
- `serve` - Static file server
- `http-server` - Simple HTTP server
- `live-server` - Development server with live reload
- `json-server` - REST API server from JSON files

### Development Utilities
- `nodemon` - Auto-restart on file changes
- `concurrently` - Run multiple commands concurrently
- `cross-env` - Cross-platform environment variables
- `rimraf` - Cross-platform rm -rf
- `npm-check-updates` - Update package.json dependencies
- `pm2` - Process manager for Node.js apps

### TypeScript Support
- `typescript` - TypeScript compiler
- `ts-node` - Run TypeScript directly
- `@types/node` - Node.js type definitions

## Smart Package Manager

The feature includes a `pm` command that automatically detects and uses the appropriate package manager based on lock files in your project:

- Detects `pnpm-lock.yaml` → uses pnpm
- Detects `yarn.lock` → uses yarn  
- Detects `package-lock.json` → uses npm
- Falls back to preference order: pnpm → yarn → npm

### Usage Examples

```bash
pm install          # Install dependencies
pm add lodash       # Add package
pm dev @types/node  # Add dev dependency
pm remove lodash    # Remove package
pm run build       # Run script
pm exec tsc        # Execute command
```

Run `node-info` in your container to see all installed tools and versions.