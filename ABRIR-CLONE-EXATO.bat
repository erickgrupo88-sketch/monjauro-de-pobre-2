@echo off
cd /d "%~dp0"
start "Mounjaro Clone Server" cmd /k ""C:\Users\erick\AppData\Local\OpenAI\Codex\bin\node.exe" "%~dp0server.js""
timeout /t 2 >nul
start "" "http://localhost:8080/?utm_source=instagram&utm_campaign=bio"
