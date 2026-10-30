@echo off
chcp 65001 >nul
echo =======================================================
echo [ADMIN] DANG KICH HOAT CHE DO BAO TRI HE THONG...
echo =======================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bat_bao_tri.ps1"
echo.
echo =======================================================
echo [THONG BAO] Che do bao tri DA DUOC BAT!
echo Luc nay moi request tu App se bi chan (503 Service Unavailable).
echo =======================================================
pause
