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

set cert=Not found
for /f %%i in ('.\bin\windows\sed.exe -n "s/apkFileName: \(.*\)/\1/p" Disassembled\apktool.yml') do set apkFileName=%%i
for /f %%i in ('.\bin\windows\sed.exe -n "s/version: \(.*\)/\1/p" Disassembled\apktool.yml') do set version=%%i
for /f %%i in ('.\bin\windows\sed.exe -n "s/minSdkVersion: '\(.*\)'/\1/p" Disassembled\apktool.yml') do set minSdkVersion=%%i
for /f %%i in ('.\bin\windows\sed.exe -n "s/targetSdkVersion: '\(.*\)'/\1/p" Disassembled\apktool.yml') do set targetSdkVersion=%%i
for /f %%i in ('.\bin\windows\sed.exe -n "s/versionCode: '\(.*\)'/\1/p" Disassembled\apktool.yml') do set versionCode=%%i
for /f %%i in ('.\bin\windows\sed.exe -n "s/versionName: \(.*\)/\1/p" Disassembled\apktool.yml') do set versionName=%%i
for /r %%x in (*.RSA) do set cert=%%x

echo !\n!apkName: %apkFileName%
echo version: %version%
echo minSdkVersion: %minSdkVersion%
echo targetSdkVersion: %targetSdkVersion%
echo versionCode: %versionCode%
echo versionName: %versionName%

echo !\n![INFO] Certificate information:
if not "%cert%"=="Not found" (
    keytool -printcert -file %cert%
    echo !\n![INFO] Export to rfc:
    keytool -printcert -rfc -file %cert%
) else (
    echo %cert%
)
echo [INFO] Finished