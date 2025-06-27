# Git Aliases & Shortcuts

This feature installs useful git aliases and shortcuts to speed up your development workflow.

## Usage

```json
"features": {
    "ghcr.io/eviljoshspicer-features/git-aliases:1": {
        "includeAdvanced": true,
        "includePrettyLog": true
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `includeAdvanced` | boolean | `true` | Include advanced git aliases like interactive rebase shortcuts |
| `includePrettyLog` | boolean | `true` | Include pretty log formatting aliases |

## Installed Aliases

### Basic Aliases
- `git st` - status
- `git co` - checkout
- `git br` - branch  
- `git cm` - commit
- `git cma` - commit --amend
- `git unstage` - reset HEAD --
- `git last` - log -1 HEAD
- `git visual` - gitk

### Pretty Log (when enabled)
- `git lg` - pretty log with graph
- `git lga` - pretty log with graph (all branches)

### Advanced (when enabled)
- `git undo` - undo last commit (keep changes)
- `git amend` - amend with all changes
- `git wipe` - create savepoint then hard reset
- `git bclean` - delete merged branches
- `git bdone` - checkout master, update, clean branches
- `git up` - update and fast-forward merge

Run `git-help` in your container to see all available shortcuts.