@echo off
cd /d f:\EconomicqsMaster\web-project\backend
start cmd /k "npm install && npm run dev"
timeout /t 3
cd /d f:\EconomicqsMaster\web-project\frontend
start cmd /k "npm install && npm run dev"
pause
