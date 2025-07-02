# Developer Fortune

This feature provides daily motivational quotes and tips specifically for developers.

## Usage

```bash
devfortune
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| category | Choose the type of fortunes to display | string | mixed |

### Category Options

- `motivational`: Inspirational quotes to keep you motivated
- `technical`: Programming wisdom and technical insights  
- `funny`: Humorous programming jokes and observations
- `mixed`: Random selection from all categories

## Examples

```jsonc
"features": {
    "ghcr.io/eviljoshspicer/eviljoshspicer-features/fortune:1": {
        "category": "motivational"
    }
}
```

The feature installs a `devfortune` command that displays random developer-focused quotes to brighten your day and keep you motivated while coding!