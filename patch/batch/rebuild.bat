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