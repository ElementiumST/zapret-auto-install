$ErrorActionPreference = "Stop"

$url = "https://github.com/Flowseal/zapret-discord-youtube/releases/download/1.9.7b/zapret-discord-youtube-1.9.7b.zip"
$zip = "$env:TEMP\zapret.zip"
$dest = "C:\zapret"

Write-Host "[1/5] Downloading..."
Invoke-WebRequest $url -OutFile $zip

Write-Host "[2/5] Extracting..."
Expand-Archive -Path $zip -DestinationPath $dest -Force

Write-Host "[3/5] Entering directory..."
Set-Location $dest

Write-Host "[4/5] Running service.bat..."

# Запуск cmd с возможностью писать в stdin
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "cmd.exe"
$psi.Arguments = "/c service.bat"
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $psi
$process.Start() | Out-Null

Start-Sleep 2
$process.StandardInput.WriteLine("1")

Start-Sleep 2
$process.StandardInput.WriteLine("6")

# Читаем вывод и ждём нужную строку
while (-not $process.HasExited) {
    $line = $process.StandardOutput.ReadLine()
    if ($line) {
        Write-Host $line
        if ($line -match "The operation completed successfully.") {
            break
        }
    }
}

$process.Kill()

Write-Host "[5/5] Done!"
