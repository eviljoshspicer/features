# ASCII Art Banner

This feature provides beautiful ASCII art banner generation for your development projects.

## Usage

```bash
# Generate banner with default text
ascii-banner

# Generate banner with custom text  
ascii-banner "My Project"

# Colorful welcome banner
welcome-banner "Hello World"
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| style | Choose the ASCII art style | string | standard |
| defaultText | Default text when no argument provided | string | DevContainer |

### Style Options

- `standard`: Classic figlet font
- `slant`: Slanted text style
- `big`: Large bold letters
- `block`: Block letter style  
- `bubble`: Bubble letter style

## Examples

```jsonc
"features": {
    "ghcr.io/eviljoshspicer/eviljoshspicer-features/ascii-art:1": {
        "style": "slant",
        "defaultText": "My App"
    }
}
```

Perfect for creating eye-catching project headers, welcome messages, and terminal art!