@echo off
setlocal
title Abrir Clone Mounjaro de Pobre

set "PROJECT_DIR=%~dp0"
set "NODE_EXE=C:\Users\erick\AppData\Local\OpenAI\Codex\bin\node.exe"
set "URL=http://localhost:8080/?utm_source=instagram&utm_campaign=bio"

cd /d "%PROJECT_DIR%"

if not exist "%NODE_EXE%" (
  echo.
  echo ERRO: Node.js nao foi encontrado em:
  echo %NODE_EXE%
  echo.
  echo Abra o Codex e me avise para eu ajustar o caminho do Node.
  pause
  exit /b 1
)

if not exist "%PROJECT_DIR%server.js" (
  echo.
  echo ERRO: server.js nao foi encontrado nesta pasta:
  echo %PROJECT_DIR%
  echo.
  pause
  exit /b 1
)

echo.
echo Iniciando o clone...
echo Pasta: %PROJECT_DIR%
echo URL:   %URL%
echo.

start "Servidor Mounjaro" cmd /k ""%NODE_EXE%" "%PROJECT_DIR%server.js""
timeout /t 3 /nobreak >nul
start "" "%URL%"

echo.
echo Se a pagina nao abrir automaticamente, copie e cole este link no navegador:
echo %URL%
echo.
exit /b 0
