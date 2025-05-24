# Automated script to retune and reset Git repository settings, prompting for user info

Write-Host "=== Git Repository Retune Script ===" -ForegroundColor Cyan

# Prompt for user name and email
$userName = Read-Host "Enter your Git user name"
$userEmail = Read-Host "Enter your Git email address"

# Set user name and email globally
git config --global user.name "$userName"
git config --global user.email "$userEmail"
Write-Host "Git user.name and user.email set globally." -ForegroundColor Green

# Initialize repo if needed
if (-not (Test-Path ".git")) {
    git init
    Write-Host "Initialized a new Git repository." -ForegroundColor Green
}

# Add all files and make an initial commit if no commits exist
$commitCount = git rev-list --count HEAD 2>$null
if ($commitCount -eq 0) {
    git add .
    git commit -m "Initial commit: clean setup"
    Write-Host "Initial commit created." -ForegroundColor Green
}

# Prompt for remote URL
$remoteUrl = Read-Host "Enter remote repository URL (or leave blank to skip)"
if ($remoteUrl) {
    # Remove old origin if exists
    if (git remote | Select-String "origin") {
        git remote remove origin
    }
    git remote add origin $remoteUrl
    Write-Host "Remote 'origin' set to $remoteUrl" -ForegroundColor Green
}

# Set default branch to main
git branch -M main

# Push to remote if set
if ($remoteUrl) {
    git push -u origin main
    Write-Host "Pushed to remote repository." -ForegroundColor Green
}

# Stage and commit pre-commit config if present and changed
if (Test-Path ".pre-commit-config.yaml") {
    git add .pre-commit-config.yaml
    git commit -m "Update pre-commit config" 2>$null
    Write-Host ".pre-commit-config.yaml staged and committed." -ForegroundColor Green
}

Write-Host "=== Git repository retune complete! ===" -ForegroundColor Cyan
