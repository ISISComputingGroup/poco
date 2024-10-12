setlocal
set "TOPDIR=%~dp0"

if "%1" == "DEBUG" (
    set "BUILD_TYPE=Debug"
    set "INSTALL_NAME=debug_shared"
) else (
REM    set "BUILD_TYPE=RelWithDebInfo"
    set "BUILD_TYPE=Release"
    set "INSTALL_NAME=release_shared"
)
set "INSTALL_ROOT=%TOPDIR%\%INSTALL_NAME%"

REM if updating poco make sure ISISICP is updated to same sqlite version bundled with poco

set "KITSDIR=\\isis.cclrc.ac.uk\inst$\kits$\CompGroup\ICP\ISISICP\ThirdPartyKits"
"c:\Program Files\7-Zip\7z.exe" x "%KITSDIR%\openssl-3.0.15.zip" -aoa
"c:\Program Files\7-Zip\7z.exe" x "%KITSDIR%\mysql-8.4.2-winx64.zip" -aoa
"c:\Program Files\7-Zip\7z.exe" x "%KITSDIR%\mysql-8.4.2-winx64-debug-test.zip" -aoa

copy /y mysql-8.4.2-winx64\include\mysql.h mysql-8.4.2-winx64\include\mysql\mysql.h
set "LINK=/LIBPATH:"%TOPDIR%mysql-8.4.2-winx64\lib""

rmdir /q /s cmake-build
rmdir /q /s %INSTALL_ROOT%
mkdir cmake-build
cd cmake-build

for %%X in (cmake.exe) do ( set "FOUND_CMAKE=%%~$PATH:X" )
if not exist "%FOUND_CMAKE%" (
    set "PATH=%ProgramFiles%\CMake\bin;%PATH%"
)

cmake -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
    -DCMAKE_INSTALL_PREFIX=%INSTALL_ROOT% ^
    -DOPENSSL_ROOT_DIR=%TOPDIR%openssl-3.0\x64 ^
    -DMYSQL_ROOT_DIR=%TOPDIR%mysql-8.4.2-winx64 ..
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --config %BUILD_TYPE%
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --install . --prefix %INSTALL_ROOT%
if %errorlevel% neq 0 exit /b %errorlevel%

xcopy /y %TOPDIR%mysql-8.4.2-winx64\bin\*.dll %INSTALL_ROOT%\bin
if %errorlevel% neq 0 exit /b %errorlevel%
xcopy /y %TOPDIR%mysql-8.4.2-winx64\lib\libmysql.dll %INSTALL_ROOT%\bin
if %errorlevel% neq 0 exit /b %errorlevel%
xcopy /y %TOPDIR%mysql-8.4.2-winx64\lib\libmysql.lib %INSTALL_ROOT%\lib
if %errorlevel% neq 0 exit /b %errorlevel%

xcopy /y %TOPDIR%openssl-3.0\x64\bin\*.dll %INSTALL_ROOT%\bin
if %errorlevel% neq 0 exit /b %errorlevel%
xcopy /y %TOPDIR%openssl-3.0\x64\lib\*.lib %INSTALL_ROOT%\lib
if %errorlevel% neq 0 exit /b %errorlevel%

robocopy "%TOPDIR%mysql-8.4.2-winx64\include" "%INSTALL_ROOT%\include\mysql" /MIR /R:2 /NFL /NDL /NP
if %errorlevel% geq 4 exit /b %errorlevel%

robocopy "%INSTALL_ROOT%" "\\isis.cclrc.ac.uk\inst$\Kits$\CompGroup\ICP\ISISICP\POCO\%INSTALL_NAME%" /MIR /R:2 /NFL /NDL /NP
if %errorlevel% geq 4 exit /b %errorlevel%

exit /b 0
