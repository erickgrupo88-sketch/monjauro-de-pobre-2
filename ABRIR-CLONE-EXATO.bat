@echo off
cd /d "%~dp0"
start "Mounjaro Clone Server" cmd /k "node server.js"
timeout /t 2 >nul
start "" "http://localhost:8080/?utm_source=instagram&utm_campaign=bio"
