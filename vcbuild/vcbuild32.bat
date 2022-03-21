@ECHO off

set dbg=0
set machine=ppro

:getopt
if "%~1"=="/d" (set dbg=1) & shift & goto getopt
if "%~1"=="/m" (set machine=%2) & shift & shift & goto getopt

if "%machine%"=="ppro" goto success
if "%machine%"=="ansi32" goto success
if "%machine%"=="ansi-legacy" goto success
echo "valid values for /m are [ppro, ansi32, ansi-legacy]"
exit /b 1
:success

"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere" -latest -property installationPath > vcpath.txt
set /p vcpath=<vcpath.txt
del vcpath.txt
call "%vcpath%\VC\Auxiliary\Build\vcvarsall.bat" x86

if not exist dist32 mkdir dist32
if exist dist32\* del /q dist32\*

cd ..\libmpdec
copy /y Makefile.vc Makefile
nmake clean
nmake MACHINE=%machine% DEBUG=%dbg%

copy /y "libmpdec-2.5.1.lib" ..\vcbuild\dist32
copy /y "libmpdec-2.5.1.dll" ..\vcbuild\dist32
copy /y "libmpdec-2.5.1.dll.lib" ..\vcbuild\dist32
copy /y "libmpdec-2.5.1.dll.exp" ..\vcbuild\dist32
copy /y "mpdecimal.h" ..\vcbuild\dist32


cd ..\libmpdec++
copy /y Makefile.vc Makefile
nmake clean
nmake DEBUG=%dbg%

copy /y "libmpdec++-2.5.1.lib" ..\vcbuild\dist32
copy /y "libmpdec++-2.5.1.dll" ..\vcbuild\dist32
copy /y "libmpdec++-2.5.1.dll.lib" ..\vcbuild\dist32
copy /y "libmpdec++-2.5.1.dll.exp" ..\vcbuild\dist32
copy /y "decimal.hh" ..\vcbuild\dist32


cd ..\vcbuild



