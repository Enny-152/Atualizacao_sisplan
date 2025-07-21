@echo off
setlocal enabledelayedexpansion
color 0E

@echo off
setlocal enabledelayedexpansion
color 0E

set "ini=C:\Sisplan\Sisplan.ini"

rem Lê o arquivo de texto e encontra a linha com "servidor="
for /f "tokens=2 delims==" %%i in ('findstr /i "servidor=" %ini%') do (
    set "ipini=%%i"
)

rem Remove qualquer caractere de dois pontos ":" que possa estar no final do IP
set "ipServ=%ipini::=%"

rem Obter o IP atual do computador
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4"') do (
    for /f "tokens=1 delims= " %%j in ("%%i") do (
        set "ipLocal=%%j"
    )
)

rem Compara o IP do arquivo com o IP atual do computador
if "%ipServ%"=="%ipLocal%" (
    echo Serv %ipServ%
    echo Local %ipLocal%
    echo Os IPs sao iguais.
) else (
    echo Serv %ipServ%
    echo Local %ipLocal%
    echo Os IPs sao diferentes.
)

pause
