@echo off
chcp 65001 >nul
title MoneyPod - Khởi Chạy Bằng Docker Compose (ThanhPhat)

echo ===============================================================
echo     🐳 KHỞI CHẠY HỆ THỐNG MONEYPOD BẰNG DOCKER COMPOSE
echo     Tác giả / Báo cáo: ThanhPhat (phatta@xboss.com)
echo ===============================================================
echo.

:: 1. Tạm dừng service PostgreSQL trên Windows để tránh đụng độ cổng 5432
echo [1/4] Đang giải phóng cổng 5432 (tạm dừng PostgreSQL Service của Windows)...
net stop postgresql-x64-15 >nul 2>&1

:: 2. Kiểm tra Docker Desktop
echo.
echo [2/4] Đang kiểm tra Docker Desktop...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo   -> Docker Desktop chưa bật. Đang khởi động Docker Desktop...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo   -> Vui lòng đợi Docker khởi động hoàn tất (khoảng 20-30 giây)...
    :WAIT_DOCKER
    timeout /t 5 /nobreak >nul
    docker info >nul 2>&1
    if %errorlevel% neq 0 (
        echo   ...đang đợi Docker Engine sẵn sàng...
        goto WAIT_DOCKER
    )
)
echo   -> Docker Engine: SẴN SÀNG!

:: 3. Khởi động các container qua Docker Compose
echo.
echo [3/4] Đang dựng và chạy các Container (PostgreSQL + Go Backend)...
cd /d "%~dp0server"
docker compose up -d --build

:: 4. Khởi động Máy ảo Android & App MoneyPod
echo.
echo [4/4] Đang kiểm tra Máy ảo Android và Ứng dụng...
where adb >nul 2>&1
if %errorlevel% neq 0 (
    set "PATH=%PATH%;C:\Users\DELL\AppData\Local\Android\Sdk\platform-tools;C:\Users\DELL\AppData\Local\Android\Sdk\emulator"
)

adb devices | findstr /i "emulator" >nul 2>&1
if %errorlevel% neq 0 (
    echo   -> Đang mở máy ảo Pixel_7...
    start "Pixel 7 Emulator" emulator -avd Pixel_7
    echo   -> Đang đợi máy ảo khởi động...
    adb wait-for-device
) else (
    echo   -> Máy ảo Android đã mở sẵn!
)

echo   -> Đang mở ứng dụng MoneyPod...
adb shell am start -n com.example.app/com.example.app.MainActivity >nul 2>&1

echo.
echo ===============================================================
echo     ✅ TOÀN BỘ HỆ THỐNG DOCKER ĐÃ HOẠT ĐỘNG!
echo.
echo     🐳 Container Database: moneypod_db (PostgreSQL 16)
echo     🐳 Container Backend:  moneypod_api (Port 8080)
echo.
echo     📌 Backend URL: http://localhost:8080/api/v1
echo     📌 Dừng Docker khi xong: cd server ^&^& docker compose down
echo ===============================================================
pause
