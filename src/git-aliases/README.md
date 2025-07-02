# Git Power Aliases

This feature installs a comprehensive set of git aliases and shortcuts to boost your productivity.

## Usage

After installation, you can use short git commands like:

```bash
git st          # status
git co main     # checkout main
git ci -m "msg" # commit with message
git adog        # beautiful log graph
git tree        # commit tree view
```

Use the helper command to see all available aliases:

```bash
git-help-aliases
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| includeAdvanced | Include advanced git aliases | boolean | true |
| includeShortcuts | Include basic shortcut aliases | boolean | true |

## Included Aliases

### Basic Shortcuts (when includeShortcuts=true)
- `st` → `status`
- `co` → `checkout` 
- `br` → `branch`
- `ci` → `commit`
- `df` → `diff`
- `dc` → `diff --cached`
- `lg` → `log --oneline --graph --decorate`
- `last` → `log -1 HEAD`
- `unstage` → `reset HEAD --`

### Advanced Aliases (when includeAdvanced=true)
- `adog` → Beautiful log with all branches
- `tree` → Colorful commit tree view
- `amend` → `commit --amend`
- `undo` → `reset --soft HEAD^`
- `cleanup` → Delete merged branches
- `recent` → Show branches by recent activity
- `save` → Stage all and stash
- `pop` → `stash pop`
- `count` → Contributor statistics

## Examples

```jsonc
"features": {
    "ghcr.io/eviljoshspicer/eviljoshspicer-features/git-aliases:1": {
        "includeAdvanced": true,
        "includeShortcuts": true
    }
}
```

Perfect for developers who want to speed up their git workflow!