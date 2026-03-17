<#
.SYNOPSIS
    Sets up the Copilot commit message generation prepare-commit-msg hook.

.DESCRIPTION
    This script installs the prepare-commit-msg hook that automatically generates
    concise commit messages using GitHub Copilot CLI (copilot -p) with GPT-5 mini.

.NOTES
    - Requires copilot CLI to be installed and configured
    - Requires Git to be installed
    - The hook only works in interactive shell environments
#>

param(
    [switch]$Force
)

$repoRoot = git rev-parse --show-toplevel 2>$null
if (-not $repoRoot) {
    Write-Error "Not in a git repository. Please run this script from within a git repository."
    exit 1
}

$hooksDir = Join-Path $repoRoot ".git" "hooks"
$prepareCommitMsgHook = Join-Path $hooksDir "prepare-commit-msg"

if (-not (Test-Path $hooksDir)) {
    Write-Error "Git hooks directory not found: $hooksDir"
    exit 1
}

# Check if hook already exists
if ((Test-Path $prepareCommitMsgHook) -and -not $Force) {
    $content = Get-Content $prepareCommitMsgHook
    if ($content -match "copilot") {
        Write-Output "✓ Copilot prepare-commit-msg hook is already installed."
        exit 0
    } else {
        Write-Warning "A different prepare-commit-msg hook already exists. Use -Force to override."
        exit 1
    }
}

# Verify copilot is installed
$copilotVersion = & copilot --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "copilot CLI not found. Please install it first."
    Write-Host "See: https://docs.github.com/copilot/how-tos/copilot-cli"
    exit 1
}

Write-Output "📦 GitHub Copilot CLI found: $copilotVersion"

# Create or update the hook
$hookContent = @'
#!/bin/bash
# prepare-commit-msg hook to generate git commit messages using copilot -p
# This hook generates concise commit messages using GitHub Copilot CLI

# Get the staged diff
STAGED_DIFF=$(git diff --cached 2>/dev/null)

# If no staged changes, exit silently (don't modify commit message)
if [ -z "$STAGED_DIFF" ]; then
    exit 0
fi

# Limit diff to first 5000 characters to avoid token limits
STAGED_DIFF_LIMITED="${STAGED_DIFF:0:5000}"

# Create a prompt for copilot
PROMPT="Generate a concise 1-2 sentence git commit message for the following staged code changes. Be brief and direct, focus on WHAT changed, not HOW:

\`\`\`diff
$STAGED_DIFF_LIMITED
\`\`\`

Return ONLY the commit message text, no quotes, no markdown, no explanation."

# Generate commit message using copilot
echo "🤖 Generating commit message with Copilot..."
COMMIT_MESSAGE=$(copilot -p "$PROMPT" --model gpt-5-mini -s --allow-all-tools 2>/dev/null | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

# If generation failed or returned empty, don't modify commit message
if [ -z "$COMMIT_MESSAGE" ]; then
    echo "⚠️  Could not generate commit message."
    exit 0
fi

# Display the generated message
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Generated Commit Message:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$COMMIT_MESSAGE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if stdin is available (interactive mode)
if [ -t 0 ]; then
    # Interactive mode: ask user for confirmation
    read -p "✓ Use this message? (y/n) [y=yes, n=abort]: " -n 1 -r REPLY
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Accept: write the message to the commit message file
        echo "$COMMIT_MESSAGE" > "$1"
        exit 0
    else
        # Reject: don't modify the commit message (user will be prompted by git)
        exit 0
    fi
else
    # Non-interactive mode: auto-accept and write message
    echo "✓ (auto-accepting in non-interactive mode)"
    echo "$COMMIT_MESSAGE" > "$1"
    exit 0
fi
'@

# Write the hook
Set-Content -Path $prepareCommitMsgHook -Value $hookContent -Encoding UTF8

# Make it executable on Unix-like systems
if ($PSVersionTable.Platform -eq "Unix" -or $PSVersionTable.OS -like "*Linux*" -or $PSVersionTable.OS -like "*Darwin*") {
    & chmod +x $prepareCommitMsgHook
}

Write-Output "✅ Copilot prepare-commit-msg hook installed successfully!"
Write-Output ""
Write-Output "📝 How it works:"
Write-Output "  1. When you run 'git commit', the hook generates a message using Copilot"
Write-Output "  2. Review the suggested message and choose:"
Write-Output "     - 'y' to use it"
Write-Output "     - 'n' to write your own message"
Write-Output ""
Write-Output "🔧 To disable the hook temporarily, run:"
Write-Output "   git commit --no-verify"
Write-Output ""
Write-Output "🗑️  To remove the hook, run:"
Write-Output "   Remove-Item '$prepareCommitMsgHook'"
