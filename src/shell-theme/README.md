# Enhanced Shell Theme

This feature provides beautiful, customizable shell prompts with git integration and colors to enhance your terminal experience.

## Usage

The theme is automatically applied when you open a new shell. You can also switch themes dynamically:

```bash
# See available themes
switch-theme

# Change to a different theme
switch-theme powerline
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| theme | Choose the shell prompt theme | string | git-focused |
| showGitInfo | Show git branch and status in prompt | boolean | true |
| showTime | Show current time in prompt | boolean | false |

## Available Themes

### minimal
Clean and simple prompt:
```
user Documents/project (main●) $
```

### powerline  
Multi-line prompt with full info:
```
[14:30:15] user@hostname ~/Documents/project (main●)
❯
```

### git-focused (default)
Perfect balance with git emphasis:
```
user:~/Documents/project (main●) $
```

### full
Feature-rich multi-line prompt:
```
[14:30:15] user@hostname ~/Documents/project (main●)
❯
```

## Git Status Indicators

- 🟢 **Green dot (●)**: Clean working directory
- 🔴 **Red dot (●)**: Uncommitted changes
- **Branch name**: Current git branch

## Examples

```jsonc
"features": {
    "ghcr.io/eviljoshspicer/eviljoshspicer-features/shell-theme:1": {
        "theme": "powerline",
        "showGitInfo": true,
        "showTime": true
    }
}
```

Perfect for developers who want a beautiful, informative terminal experience!