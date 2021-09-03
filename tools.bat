@echo off

REM MIT License
REM 
REM Copyright (c) 2021 Luca
REM 
REM Permission is hereby granted, free of charge, to any person obtaining a copy
REM of this software and associated documentation files (the "Software"), to deal
REM in the Software without restriction, including without limitation the rights
REM to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
REM copies of the Software, and to permit persons to whom the Software is
REM furnished to do so, subject to the following conditions:
REM 
REM The above copyright notice and this permission notice shall be included in all
REM copies or substantial portions of the Software.
REM 
REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
REM IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
REM AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
REM OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
REM SOFTWARE.

setlocal EnableDelayedExpansion
(set \n=^
%=This is Mandatory Space=%
)

echo ^# ============================== ^#
echo ^|          Apk-Mod-Tools         ^|
echo ^|            By LukeAz           ^|
echo ^# ============================== ^#

where java
if %ERRORLEVEL% NEQ 0 (
    echo !\n!"Java not installed, please install it from https://www.java.com/download/ie_manual.jsp"
    timeout /t 5
    exit
)

set "OPTIONS=!\n!Select one of this options:!\n!1) Display information about an apk!\n!2) Disassemble an apk to convert it to smali code!\n!3) Switch enable/disable extractNativeLibs!\n!4) It shows the name of the file in which a string is contained from the input, you can use the regex!\n!5) Replace a string contained in a specific smali file with another string taken as input!\n!6) Try to remove ssl pinning!\n!7) Search for any files that contain apk signature verification!\n!8) Rebuild apk!\n!9) Exit!\n!"

:loop
echo !OPTIONS!
set /p INPUT=Your select: %=%

if "%INPUT%" == "2" goto :disassemble
if "%INPUT%" == "9" goto :theend

if not exist Disassembled (
    echo [INFO] You need disassemble apk before catch info, use 2 on menu
    goto :loop
) else (
    if "%INPUT%" == "1" goto :apkinfo
    if "%INPUT%" == "3" goto :extractNativeLibs
    if "%INPUT%" == "4" goto :findstring
    if "%INPUT%" == "5" goto :replacestring
    if "%INPUT%" == "6" goto :sslunpinning
    if "%INPUT%" == "7" goto :searchsignatures
    if "%INPUT%" == "8" goto :rebuildapk
)

echo command not found
goto :loop

:apkinfo
call "./patch/batch/apkinfo.bat"
goto :loop

:disassemble
call "./patch/batch/disassemble.bat"
goto :loop

:extractNativeLibs
call "./patch/batch/extractNativeLibs.bat"
goto :loop

:findstring
call "./patch/batch/findstring.bat"
goto :loop

:replacestring
call "./patch/batch/replacestring.bat"
goto :loop

:sslunpinning
call "./patch/batch/sslunpinning.bat"
goto :loop

:searchsignatures
call "./patch/batch/searchsignatures.bat"
goto :loop

:rebuildapk
call "./patch/batch/rebuild.bat"
goto :loop

:theend