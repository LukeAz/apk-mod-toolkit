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

set DIRECTORY=%~dp0

echo [INFO] Adding custom TrustManager class
mkdir "Disassembled/smali/sslunpinning"
copy /y "%DIRECTORY%..\smali\sslunpinning\bypasstrustmanager.smali" "%DIRECTORY%..\..\Disassembled\smali\sslunpinning\."
copy /y "%DIRECTORY%..\smali\sslunpinning\bypasstrustmanager$1.smali" "%DIRECTORY%..\..\Disassembled\smali\sslunpinning\."

echo [INFO] Searching and patching TrustManager implementation
for /f %%G in ('findstr /r /S /M /C:"new-array v., v., \[Ljavax/net/ssl/TrustManager;" *.smali') do (
    echo   -^> Matched: %%G
    for /f %%i in ('.\bin\windows\sed.exe -n "s/.*invoke-virtual {.., \(..\), .., ..}, Ljavax\/net\/ssl\/SSLContext;->init(\[Ljavax\/net\/ssl\/KeyManager;\[Ljavax\/net\/ssl\/TrustManager;Ljava\/security\/SecureRandom;)V.*/\1/p" %%G') do set "variable=%%i"
    "./bin/windows/sed.exe" -i "s#new-array .., .., \[Ljavax/net/ssl/TrustManager;#& \n    invoke-static {}, Lsslunpinning/bypasstrustmanager;->getInstance()Ljavax/net/ssl/TrustManager;\n    move-result-object !variable!#" %%G
    echo   -^> TrustManager patched
)

echo [INFO] Searching okhttp3 CertificatePinner
for /f %%G in ('findstr /S /M /C:".class public final Lokhttp3/CertificatePinner;" *.smali') do (
    echo   -^> Matched: %%G
    "./bin/windows/sed.exe" -i "s#.method public final.*check(.*)V#& \n    return-void#" %%G
    echo   -^> okhttp3 CertificatePinner patched
)

echo [INFO] Searching babylon certificatetransparency
for /f %%G in ('findstr /r /S /M /C:"\.class public final L.*/babylon/certificatetransparency/internal/verifier/model/Host;" *.smali') do (
    echo   -^> Matched: %%G
    "./bin/windows/sed.exe" -i "s#const-string .., .hostname.#const/4 v0, 0x1\n    return v0#g" %%G
    echo   -^> Certificatetransparency patched
)

echo [INFO] Finished