#!/bin/sh
set -e

echo "Activating feature 'git-aliases'"
echo "Include advanced aliases: ${INCLUDEADVANCED}"
echo "Include shortcuts: ${INCLUDESHORTCUTS}"

# Function to set git config for all users
set_git_config() {
    # Set for root
    git config --global "$1" "$2"
    
    # Set for remote user if different from root
    if [ -n "$_REMOTE_USER" ] && [ "$_REMOTE_USER" != "root" ]; then
        su "$_REMOTE_USER" -c "git config --global '$1' '$2'"
    fi
    
    # Set for container user if different from others
    if [ -n "$_CONTAINER_USER" ] && [ "$_CONTAINER_USER" != "root" ] && [ "$_CONTAINER_USER" != "$_REMOTE_USER" ]; then
        su "$_CONTAINER_USER" -c "git config --global '$1' '$2'"
    fi
}

# Basic shortcuts
if [ "${INCLUDESHORTCUTS}" = "true" ]; then
    echo "Installing basic git shortcuts..."
    
    set_git_config alias.st "status"
    set_git_config alias.co "checkout"
    set_git_config alias.br "branch"
    set_git_config alias.ci "commit"
    set_git_config alias.df "diff"
    set_git_config alias.dc "diff --cached"
    set_git_config alias.lg "log --oneline --graph --decorate"
    set_git_config alias.last "log -1 HEAD"
    set_git_config alias.unstage "reset HEAD --"
    set_git_config alias.visual "!gitk"
fi

# Advanced aliases
if [ "${INCLUDEADVANCED}" = "true" ]; then
    echo "Installing advanced git aliases..."
    
    # Beautiful log with graph
    set_git_config alias.adog "log --all --decorate --oneline --graph"
    set_git_config alias.tree "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    
    # Useful shortcuts
    set_git_config alias.aliases "config --get-regexp alias"
    set_git_config alias.amend "commit --amend"
    set_git_config alias.undo "reset --soft HEAD^"
    set_git_config alias.count "!git shortlog -sn"
    
    # Branch management
    set_git_config alias.cleanup "!git branch --merged | grep -v '\\*\\|master\\|main\\|develop' | xargs -n 1 git branch -d"
    set_git_config alias.recent "branch --sort=-committerdate"
    
    # Stash shortcuts
    set_git_config alias.save "!git add -A && git stash save"
    set_git_config alias.pop "stash pop"
    
    # Interactive commands
    set_git_config alias.interactive-rebase "rebase -i"
    set_git_config alias.pick "cherry-pick"
    
    # Search in code
    set_git_config alias.grep "grep -Ii"
    set_git_config alias.find "!git ls-files | grep -i"
fi

# Create a helper command to show all available aliases
cat > /usr/local/bin/git-help-aliases \
<< 'EOF'
#!/bin/sh

echo "🚀 Available Git Aliases:"
echo "========================"
echo ""

echo "📝 Basic Shortcuts:"
echo "  git st        = git status"
echo "  git co        = git checkout" 
echo "  git br        = git branch"
echo "  git ci        = git commit"
echo "  git df        = git diff"
echo "  git dc        = git diff --cached"
echo "  git lg        = git log --oneline --graph --decorate"
echo "  git last      = git log -1 HEAD"
echo "  git unstage   = git reset HEAD --"
echo ""

echo "🔥 Advanced Aliases:"
echo "  git adog      = git log --all --decorate --oneline --graph"
echo "  git tree      = Beautiful commit tree view"
echo "  git amend     = git commit --amend"
echo "  git undo      = git reset --soft HEAD^"
echo "  git cleanup   = Delete merged branches"
echo "  git recent    = Show recent branches"
echo "  git save      = git add -A && git stash save"
echo "  git pop       = git stash pop"
echo "  git count     = Contributor statistics"
echo "  git aliases   = Show all configured aliases"
echo ""

echo "💡 Use 'git aliases' to see your actual git config aliases"
EOF

chmod +x /usr/local/bin/git-help-aliases

echo "Git aliases installed! Use 'git-help-aliases' to see all available shortcuts."