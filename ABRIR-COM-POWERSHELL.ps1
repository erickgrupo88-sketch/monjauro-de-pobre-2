$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$NodeExe = "C:\Users\erick\AppData\Local\OpenAI\Codex\bin\node.exe"
$Url = "http://localhost:8090/?utm_source=instagram&utm_campaign=bio"

Set-Location $ProjectDir

if (!(Test-Path $NodeExe)) {
  Write-Host "ERRO: Node.js nao foi encontrado em: $NodeExe"
  Read-Host "Pressione Enter para sair"
  exit 1
}

if (!(Test-Path (Join-Path $ProjectDir "server.js"))) {
  Write-Host "ERRO: server.js nao foi encontrado nesta pasta: $ProjectDir"
  Read-Host "Pressione Enter para sair"
  exit 1
}

$listeners = Get-NetTCPConnection -LocalPort 8090 -State Listen -ErrorAction SilentlyContinue
foreach ($listener in $listeners) {
  Stop-Process -Id $listener.OwningProcess -Force -ErrorAction SilentlyContinue
}

Start-Process -FilePath "cmd.exe" -ArgumentList "/k", "`"$NodeExe`" `"$ProjectDir\server.js`""
Start-Sleep -Seconds 3
Start-Process $Url
