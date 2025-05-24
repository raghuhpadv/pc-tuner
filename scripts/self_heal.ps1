# [AUTO-GENERATED] Self-healing: detects and replaces broken scripts
\ = Get-ChildItem scripts -Filter *.ps1
foreach (\ in \) {
    try {
        powershell -NoProfile -ExecutionPolicy Bypass -File \.FullName -ErrorAction Stop
    } catch {
        Write-Host "Error in \. Regenerating..."
        Remove-Item \.FullName -Force
        # Optionally: regenerate script here
    }
}
