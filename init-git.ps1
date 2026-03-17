# init-git.ps1
# Usage: pwsh -NoProfile -ExecutionPolicy Bypass -File "init-git.ps1"

# Check for git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git 未找到。请先安装 Git (例如: winget install --id Git.Git -e)" -ForegroundColor Yellow
    exit 1
}

# Ensure working directory is the script directory
if ($PSScriptRoot) { Set-Location $PSScriptRoot }

Write-Host "Initializing git repository in: $(Get-Location)" -ForegroundColor Cyan

git init --quiet

git config --local user.name 'hongsong97@163.com'
git config --local user.email 'hongsong97@163.com'

Write-Host "\n本地 git 配置：" -ForegroundColor Green
git config --list --local

Write-Host "\n完成。若需首次提交，请运行: git add . && git commit -m 'chore: initial commit'" -ForegroundColor Cyan
