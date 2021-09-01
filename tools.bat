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

set DIRECTORY=%~dp0
set "OPTIONS=!\n!Select one of this options:!\n!1) Display information about an apk!\n!2) Disassemble an apk to convert it to smali code!\n!3) Switch enable/disable extractNativeLibs!\n!4) It shows the name of the file in which a string is contained from the input, you can use the regex!\n!5) Replace a string contained in a specific smali file with another string taken as input!\n!6) Try to remove ssl pinning!\n!7) Search for any files that contain apk signature verification!\n!8) Rebuild apk!\n!9) Exit!\n!"

:loop
echo !OPTIONS!
set /p INPUT=Your select: %=%

if "%INPUT%" == "1" goto :apkinfo
if "%INPUT%" == "2" goto :disassemble
if "%INPUT%" == "3" goto :extractNativeLibs
if "%INPUT%" == "4" goto :findstring
if "%INPUT%" == "5" goto :replacestring
if "%INPUT%" == "6" goto :sslunpinning
if "%INPUT%" == "7" goto :searchsignatures
if "%INPUT%" == "8" goto :rebuildapk
if "%INPUT%" == "9" goto :theend
echo command not found
goto :loop

:apkinfo
if not exist Disassembled (
    echo [INFO] You need disassemble apk before catch info, use 2 on menu
    goto :loop
)
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
goto :loop

:disassemble
set /p INPUT=Enter the apk path: %=% 
echo !\n![INFO] Unpacking apk: %INPUT%
if exist Disassembled ( RMDIR /Q /S Disassembled )
java -jar bin/universal/apktool.jar d %INPUT% -o Disassembled
echo [INFO] Finished
goto :loop

:extractNativeLibs
if not exist Disassembled (
    echo [INFO] You need disassemble apk before switch extractNativeLibs, use 2 on menu
    goto :loop
)
for /f %%i in ('.\bin\windows\sed.exe -n "s/.*extractNativeLibs=\(.*\).*/\1/p" Disassembled\AndroidManifest.xml') do set "flag=%%i"
if !flag! == "true" (
    "./bin/windows/sed.exe" -i "s/extractNativeLibs=\"true\"/extractNativeLibs=\"false\"/g" "Disassembled\AndroidManifest.xml"
    echo [INFO] Switched extractNativeLibs to false
) else (
    "./bin/windows/sed.exe" -i "s/extractNativeLibs=\"false\"/extractNativeLibs=\"true\"/g" "Disassembled\AndroidManifest.xml"
    echo [INFO] Switched extractNativeLibs to true
) 
goto :loop

:findstring
if not exist Disassembled (
    echo [INFO] You need disassemble apk before search on smali files, use 2 on menu
    goto :loop
)
set /p REGEX=Do you want to use regex? yes or no: %=% 
set /p INPUT=Enter string to search on smali files, remember escape in regex: %=% 
if "%REGEX%"=="yes" (
    for /f %%G in ('findstr /r /S /M /C:"%INPUT%" *.smali') do (
        echo String found in this file: %%G
    )
) else (
    for /f %%G in ('findstr /S /M /C:"%INPUT%" *.smali') do (
        echo String found in this file: %%G
    )
)
echo [INFO] Finished
goto :loop

:replacestring
if not exist Disassembled (
    echo [INFO] You need disassemble apk before replace string on smali files, use 2 on menu
    goto :loop
)
set /p INPUT=Enter path file: %=%
set /p FIND=Enter string to replace: %=%
set /p REPLACE=Enter replace string: %=%
"./bin/windows/sed.exe" -i "s#%FIND%#%REPLACE%#g" %INPUT%
echo [INFO] Finished
goto :loop

:sslunpinning
if not exist Disassembled (
    echo [INFO] You need disassemble apk before try to remove ssl pinning, use 2 on menu
    goto :loop
)
echo [INFO] Adding custom TrustManager class
mkdir "Disassembled/smali/sslunpinning"
copy /y "%DIRECTORY%patch\sslunpinning\bypasstrustmanager.smali" "%DIRECTORY%Disassembled\smali\sslunpinning\."
copy /y "%DIRECTORY%patch\sslunpinning\bypasstrustmanager$1.smali" "%DIRECTORY%Disassembled\smali\sslunpinning\."
echo [INFO] Searching and patching TrustManager implementation
for /f %%G in ('findstr /r /S /M /C:"new-array v., v., \[Ljavax/net/ssl/TrustManager;" *.smali') do (
    echo TrustManager init finded on this file: %%G
    for /f %%i in ('.\bin\windows\sed.exe -n "s/.*invoke-virtual {.., \(..\), .., ..}, Ljavax\/net\/ssl\/SSLContext;->init(\[Ljavax\/net\/ssl\/KeyManager;\[Ljavax\/net\/ssl\/TrustManager;Ljava\/security\/SecureRandom;)V.*/\1/p" %%G') do set "variable=%%i"
    "./bin/windows/sed.exe" -i "s#new-array .., .., \[Ljavax/net/ssl/TrustManager;#& \n    invoke-static {}, Lsslunpinning/bypasstrustmanager;->getInstance()Ljavax/net/ssl/TrustManager;\n    move-result-object !variable!#" %%G
)
echo [INFO] Finished
goto :loop

:searchsignatures
if not exist Disassembled (
    echo [INFO] You need disassemble apk before you can search for possible files that contain the apk signature verification, use 2 on menu
    goto :loop
)
for /f %%G in ('findstr /S /M /C:"Landroid/content/pm/PackageInfo;->signatures" *.smali') do (
    echo Possible signature check in: %%G
)
echo [INFO] Finished
goto :loop

:rebuildapk
if not exist Disassembled (
    echo [INFO] You need disassemble apk before rebuild it, use 2 on menu
    goto :loop
)
set /p OUTPUT=What name do you want to give the apk? Without extension: %=%

echo [INFO] Repacking apk
if exist toAlign.apk ( DEL /Q toAlign.apk )
java -jar bin/universal/apktool.jar empty-framework-dir
java -jar bin/universal/apktool.jar b Disassembled -o toAlign.apk --use-aapt2

echo [INFO] Zipalign apk 
if exist %OUTPUT%.apk ( DEL /Q %OUTPUT%.apk )
"./bin/windows/zipalign.exe" -f 4 toAlign.apk %OUTPUT%.apk
DEL /Q toAlign.apk

echo [INFO] Signing apk
java -jar bin/universal/apksigner.jar sign --v3-signing-enabled false --ks "bin/sign.keystore" --ks-pass "pass:keystore" --ks-key-alias "user" "%OUTPUT%.apk"

set /p INPUT=Do you want delete Disassembled directory? (yes or no) %=%
if "%INPUT%" == "yes" (
    RMDIR /Q /S Disassembled
)
echo [INFO] Finished
goto :loop

:theend