#!/bin/sh
set -e

echo "Activating feature 'git-aliases'"

# Configure basic git aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.cma "commit --amend"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.visual "!gitk"

# Add pretty log if enabled
if [ "${INCLUDEPRETTYLOG}" = "true" ]; then
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    git config --global alias.lga "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
fi

# Add advanced aliases if enabled
if [ "${INCLUDEADVANCED}" = "true" ]; then
    git config --global alias.undo "reset HEAD~1 --mixed"
    git config --global alias.amend "commit -a --amend"
    git config --global alias.wipe "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard"
    git config --global alias.bclean "!f() { git branch --merged \${1-master} | grep -v " \${1-master}\$" | xargs -r git branch -d; }; f"
    git config --global alias.bdone "!f() { git checkout \${1-master} && git up && git bclean \${1-master}; }; f"
    git config --global alias.up "!git remote update -p; git merge --ff-only @{u}"
fi

# Create a git shortcuts info command
cat > /usr/local/bin/git-help \
<< 'EOF'
#!/bin/sh
echo "🚀 Installed Git Aliases:"
echo "  git st     - status"
echo "  git co     - checkout" 
echo "  git br     - branch"
echo "  git cm     - commit"
echo "  git cma    - commit --amend"
echo "  git unstage - reset HEAD --"
echo "  git last   - log -1 HEAD"
echo "  git visual - gitk"

if git config --global --get alias.lg > /dev/null 2>&1; then
    echo ""
    echo "📊 Pretty Log Aliases:"
    echo "  git lg     - pretty log with graph"
    echo "  git lga    - pretty log with graph (all branches)"
fi

if git config --global --get alias.undo > /dev/null 2>&1; then
    echo ""
    echo "🔧 Advanced Aliases:"
    echo "  git undo   - undo last commit (keep changes)"
    echo "  git amend  - amend with all changes"
    echo "  git wipe   - create savepoint then hard reset"
    echo "  git bclean - delete merged branches"
    echo "  git bdone  - checkout master, update, clean branches"
    echo "  git up     - update and fast-forward merge"
fi
EOF

chmod +x /usr/local/bin/git-help

echo "Git aliases installed! Run 'git-help' to see all available shortcuts."