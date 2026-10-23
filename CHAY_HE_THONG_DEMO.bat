@echo off
chcp 65001 >nul
title MoneyPod - Khởi Chạy Toàn Bộ Hệ Thống Demo (ThanhPhat)

echo ===============================================================
echo     🚀 KHỞI CHẠY HỆ THỐNG FULL-STACK MONEYPOD DEMO
echo     Tác giả / Báo cáo: ThanhPhat (phatta@xboss.com)
echo ===============================================================
echo.

:: 1. Kiểm tra & khởi động PostgreSQL
echo [1/3] Đang kiểm tra PostgreSQL Service...
net start postgresql-x64-15 >nul 2>&1
echo   -> PostgreSQL Database: SẴN SÀNG! (DB: moneypod)

:: 2. Khởi động Go Backend Server
echo.
echo [2/3] Đang khởi động Go Backend Server trên cổng 8080...
start "MoneyPod Go Server" cmd /k "cd /d %~dp0server && moneypod-server.exe"
timeout /t 3 /nobreak >nul

:: 3. Khởi động Máy ảo Android & App MoneyPod
echo.
echo [3/3] Đang kiểm tra Máy ảo Android và Ứng dụng...
where adb >nul 2>&1
if %errorlevel% neq 0 (
    set "PATH=%PATH%;C:\Users\DELL\AppData\Local\Android\Sdk\platform-tools;C:\Users\DELL\AppData\Local\Android\Sdk\emulator"
)

adb devices | findstr /i "emulator" >nul 2>&1
if %errorlevel% neq 0 (
    echo   -> Đang mở máy ảo Pixel_7...
    start "Pixel 7 Emulator" emulator -avd Pixel_7
    echo   -> Đang đợi máy ảo khởi động (khoảng 15-20s)...
    adb wait-for-device
) else (
    echo   -> Máy ảo Android đã mở sẵn!
)

echo   -> Đang mở ứng dụng MoneyPod...
adb shell am start -n com.example.app/com.example.app.MainActivity >nul 2>&1

echo.
echo ===============================================================
echo     ✅ TOÀN BỘ HỆ THỐNG ĐÃ SẴN SÀNG ĐỂ BÁO CÁO / DEMO!
echo.
echo     📌 Tài khoản thật đã tạo trong Database:
echo        - Email:    phatta@xboss.com
echo        - Mật khẩu: ThanhPhat@123
echo        - Tên:      ThanhPhat
echo.
echo     📌 Backend Server: http://localhost:8080 (Listening :8080)
echo     📌 Database: PostgreSQL (moneypod - 13 bảng dữ liệu thật)
echo ===============================================================
pause
