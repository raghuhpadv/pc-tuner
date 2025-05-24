# Automated script to fix .pre-commit-config.yaml by removing error blocks and redundant entries

$ConfigPath = ".pre-commit-config.yaml"
$BackupPath = ".pre-commit-config.yaml.bak"

# 1. Backup the existing config
if (Test-Path $ConfigPath) {
    Copy-Item $ConfigPath $BackupPath -Force
    Write-Host "Backup created: $BackupPath" -ForegroundColor Yellow
}

# 2. Write a clean, validated config
@"
repos:
  - repo: https://github.com/pycqa/flake8
    rev: 7.2.0
    hooks:
      - id: flake8
  - repo: https://github.com/psf/black
    rev: 25.1.0
    hooks:
      - id: black
  - repo: https://github.com/pre-commit/mirrors-isort
    rev: v5.10.1
    hooks:
      - id: isort
  - repo: local
    hooks:
      - id: validate-pc-tuner
        name: PC Tuner Validation
        entry: .venv/Scripts/python.exe scripts/validate.py
        language: system
        pass_filenames: false
        always_run: true
        stages: [pre-commit]
"@ | Set-Content $ConfigPath -Encoding UTF8

Write-Host "New .pre-commit-config.yaml written and cleaned." -ForegroundColor Green

# 3. Stage the config for commit
git add .pre-commit-config.yaml
Write-Host ".pre-commit-config.yaml staged for commit." -ForegroundColor Green

Write-Host "Now run: git commit -m 'Fix pre-commit config and remove errors'" -ForegroundColor Cyan
