set BRANCH=%1
set DEST=%2

rem Example `build_all_win.bat electronite-v21.2.0-beta results`

echo "Building %BRANCH% to: %DEST%"

if not exist src (
    echo "Getting sources from %BRANCH%"
    .\electronite-tools-3.bat get %BRANCH%
)

set TARGET=x64
set DEST_FILE=%DEST%\%TARGET%\dist.zip
if exist "%DEST_FILE%" (
    echo "Build Target already exists: %DEST_FILE%"
) else (
    echo "Doing Build %TARGET%"
    call build_target_win.bat %TARGET% %DEST%
)

if exist "%DEST_FILE%" (
    echo "Target built: %DEST_FILE%"
) else (
    echo "Target failed: %DEST_FILE%"
    exit /b 10
)

set TARGET=x86
set DEST_FILE=%DEST%\%TARGET%\dist.zip
if exist "%DEST_FILE%" (
    echo "Build Target already exists: %DEST_FILE%"
) else (
    echo "Doing Build %TARGET%"
    call build_target_win.bat %TARGET% %DEST%
)

if exist "%DEST_FILE%" (
    echo "Target built: %DEST_FILE%"
) else (
    echo "Target failed: %DEST_FILE%"
    exit /b 10
)

set TARGET=arm64
set DEST_FILE=%DEST%\%TARGET%\dist.zip
if exist "%DEST_FILE%" (
    echo "Build Target already exists: %DEST_FILE%"
) else (
    echo "Doing Build %TARGET%"
    call build_target_win.bat %TARGET% %DEST%
)

if exist "%DEST_FILE%" (
    echo "Target built: %DEST_FILE%"
) else (
    echo "Target failed: %DEST_FILE%"
    exit /b 10
)

