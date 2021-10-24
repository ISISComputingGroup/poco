set "PATH=c:\program files\cmake\bin;%PATH%"
if "%1" == "DEBUG" (
    set "BUILD_TYPE=Debug"
    set "INSTALL_ROOT=%CD%\debug_shared"
) else (
    set "BUILD_TYPE=RelWithDebInfo"
    set "INSTALL_ROOT=%CD%\release_shared"
)
rmdir /q /s cmake-build
rmdir /q /s %INSTALL_ROOT%
mkdir cmake-build
cd cmake-build
cmake -G "Visual Studio 16 2019 Win64" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -DCMAKE_INSTALL_PREFIX=%INSTALL_ROOT% ..
cmake --build . --target install --config %BUILD_TYPE%
