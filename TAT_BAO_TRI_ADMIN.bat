@echo off
chcp 65001 >nul
echo =======================================================
echo [ADMIN] DANG TAT CHE DO BAO TRI, MO LAI HE THONG...
echo =======================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tat_bao_tri.ps1"
echo.
echo =======================================================
echo [THANH CONG] He thong MoneyPod DA HOAT DONG TRO LAI!
echo User co the dang nhap va giao dich binh thuong.
echo =======================================================
pause
