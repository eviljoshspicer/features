# Code Quality Tools

This feature installs popular linting, formatting, and code quality tools to maintain consistent code standards across your projects.

## Usage

```json
"features": {
    "ghcr.io/eviljoshspicer-features/code-quality:1": {
        "installPrettier": true,
        "installESLint": true,
        "installBlack": true,
        "installFlake8": true,
        "installShellcheck": true,
        "installMarkdownlint": true,
        "installPreCommit": true,
        "installEditorConfig": true
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `installPrettier` | boolean | `true` | Install Prettier code formatter |
| `installESLint` | boolean | `true` | Install ESLint JavaScript linter |
| `installBlack` | boolean | `true` | Install Black Python formatter |
| `installFlake8` | boolean | `true` | Install Flake8 Python linter |
| `installShellcheck` | boolean | `true` | Install Shellcheck shell script linter |
| `installMarkdownlint` | boolean | `true` | Install markdownlint for Markdown |
| `installPreCommit` | boolean | `true` | Install pre-commit hooks framework |
| `installEditorConfig` | boolean | `true` | Create default .editorconfig file |

## Installed Tools

### Linters
- **ESLint** - JavaScript/TypeScript linting with extensible rules
- **Flake8** - Python code style and error checking
- **Shellcheck** - Shell script static analysis
- **markdownlint** - Markdown syntax and style checking

### Formatters
- **Prettier** - Opinionated code formatter for JS/TS/JSON/CSS/HTML/MD
- **Black** - Uncompromising Python code formatter

### Git Hooks
- **pre-commit** - Multi-language pre-commit hooks framework
- Automatic code quality checks before commits
- Configurable hooks for different file types

### Configuration
- **.editorconfig** - Consistent coding styles across editors
- Universal settings for indentation, line endings, etc.

## Quick Commands

### Run All Quality Checks
```bash
lint-all        # Run all available linters
format-all      # Format all code files
quality-info    # Show installed tools and usage
```

### Set Up Git Hooks
```bash
setup-precommit  # Initialize pre-commit hooks for current repo
```

### Individual Tools
```bash
# Linting
eslint .                    # JavaScript/TypeScript
flake8 .                   # Python  
shellcheck *.sh            # Shell scripts
markdownlint *.md          # Markdown

# Formatting
prettier --write "**/*.js"  # JavaScript/TypeScript/JSON
black .                     # Python
```

## Pre-commit Configuration

The feature creates a comprehensive `.pre-commit-config.yaml` with:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict

  - repo: https://github.com/psf/black
    rev: 23.3.0
    hooks:
      - id: black

  - repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
      - id: flake8

  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v3.0.0
    hooks:
      - id: prettier

  - repo: https://github.com/koalaman/shellcheck-precommit
    rev: v0.9.0
    hooks:
      - id: shellcheck
```

## EditorConfig Settings

Creates a comprehensive `.editorconfig` with:
- UTF-8 charset
- LF line endings
- Trim trailing whitespace
- Language-specific indentation (2 spaces for JS/CSS, 4 for Python)
- Final newline insertion

## Workflow Integration

### Development Workflow
1. **Code** → Write your code
2. **Lint** → Run `lint-all` to check for issues  
3. **Format** → Run `format-all` to auto-fix formatting
4. **Commit** → Pre-commit hooks run automatically

### CI/CD Integration
Use the installed tools in your CI pipeline:
```bash
# In CI/CD scripts
lint-all && echo "All quality checks passed"
```

## Supported Languages

- **JavaScript/TypeScript** - ESLint + Prettier
- **Python** - Black + Flake8  
- **Shell Scripts** - Shellcheck
- **Markdown** - markdownlint
- **JSON/YAML/CSS/HTML** - Prettier

Run `quality-info` to see all installed tools and get usage examples!