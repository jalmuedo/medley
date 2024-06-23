@echo off

set chromeLocal=%LOCALAPPDATA%\Google\Chrome\Application\
set chromeInstaller=http://dl.google.com/release2/chrome/degkhp6xv2tyzgslm53niru6am_125.0.6422.142/125.0.6422.142_chrome_installer.exe
set app=https://google.com/

::===============================================================
:: Uninstall chrome if it's found
::===============================================================
IF EXIST "%chromeLocal%"chrome.exe (
    echo Unistalling Chrome, please wait.
    for /f %%i in ('dir "%chromeLocal%" /b ^|findstr /r [0-9]') do (
        "%chromeLocal%%%i\Installer\setup.exe" "--uninstall" "--force-uninstall"
    )
) ELSE (
    echo Could not uninstall Chrome.
    set /p=Uninstall Chrome from your PC and press ENTER to continue...
)

::===============================================================
:: Download and install chrome from google
::===============================================================
IF EXIST "%LOCALAPPDATA%"chrome_installer.exe (
    echo Installing Chrome.
    start "Installing Chrome" /wait "%LOCALAPPDATA%"chrome_installer.exe /silent /install
) ELSE (
    echo Downloading Chrome, please wait.
    bitsadmin /transfer Chrome /download /priority normal "%chromeInstaller%" "%LOCALAPPDATA%"chrome_installer.exe
    start "Installing Chrome" /wait "%LOCALAPPDATA%"chrome_installer.exe /silent /install
)

::===============================================================
:: Backup of the current hosts file
::===============================================================
COPY %WINDIR%\system32\drivers\etc\hosts %WINDIR%\system32\drivers\etc\hosts.bk /a /v

::===============================================================
:: Add to hosts file the upgrade urls used by chrome
::===============================================================
SET NEWLINE=^& echo.

FIND /C /I "www.google.com/dl/" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^127.0.0.1 www.google.com/dl/>>%WINDIR%\System32\drivers\etc\hosts

FIND /C /I "dl.google.com/*" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^127.0.0.1 dl.google.com/*>>%WINDIR%\System32\drivers\etc\hosts

FIND /C /I "google.com/dl/*" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^127.0.0.1 google.com/dl/*>>%WINDIR%\System32\drivers\etc\hosts

FIND /C /I "*.gvt1.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^127.0.0.1 *.gvt1.com>>%WINDIR%\System32\drivers\etc\hosts

FIND /C /I "tools.google.com/service/update2" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^127.0.0.1 tools.google.com/service/update2>>%WINDIR%\System32\drivers\etc\hosts

FIND /C /I "update.googleapis.com/service/update2" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^127.0.0.1 update.googleapis.com/service/update2>>%WINDIR%\System32\drivers\etc\hosts

FIND /C /I "https://m.google.com/devicemanagement/data/api" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^127.0.0.1 https://m.google.com/devicemanagement/data/api>>%WINDIR%\System32\drivers\etc\hosts

FIND /C /I "mobile.l.google.com" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^127.0.0.1 mobile.l.google.com>>%WINDIR%\System32\drivers\etc\hosts

::===============================================================
:: Open website app in a new tab
::===============================================================
tasklist /nh|findstr "chrome.exe"&&start "" "%app%"

exit
