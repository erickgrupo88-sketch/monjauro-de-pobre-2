@echo off
setlocal
title Resetar e Abrir Clone Mounjaro

set "PROJECT_DIR=%~dp0"
set "NODE_EXE=C:\Users\erick\AppData\Local\OpenAI\Codex\bin\node.exe"
set "URL=http://localhost:8090/?utm_source=instagram&utm_campaign=bio"

cd /d "%PROJECT_DIR%"

echo Fechando servidores antigos nas portas 8080 e 8090...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080" ^| findstr "LISTENING"') do taskkill /PID %%a /F >nul 2>nul
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8090" ^| findstr "LISTENING"') do taskkill /PID %%a /F >nul 2>nul

echo.
echo Abrindo servidor novo em:
echo %URL%
echo.

if not exist "%NODE_EXE%" (
  echo ERRO: Node.js nao encontrado em %NODE_EXE%
  pause
  exit /b 1
)

start "Servidor Mounjaro" cmd /k ""%NODE_EXE%" "%PROJECT_DIR%server.js""
timeout /t 4 /nobreak >nul
start "" "%URL%"

echo Se nao abrir automaticamente, copie este link:
echo %URL%
exit /b 0
