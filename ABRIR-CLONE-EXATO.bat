@echo off
cd /d "%~dp0"
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8090" ^| findstr "LISTENING"') do taskkill /PID %%a /F >nul 2>nul
start "Mounjaro Clone Server" cmd /k ""C:\Users\erick\AppData\Local\OpenAI\Codex\bin\node.exe" "%~dp0server.js""
timeout /t 2 >nul
start "" "http://localhost:8090/?utm_source=instagram&utm_campaign=bio"
