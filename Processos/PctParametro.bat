@echo off
setlocal enabledelayedexpansion
color 0E

set "pct=C:\Sisplan\PctFaturamento.bpl"
set "dataComparacao=20240911 00:00:00"  rem Data de comparação no formato AAAAMMDD HH:MM:SS

rem Obtem a data de modificacao do arquivo
for /f "tokens=1,2,3,4" %%a in ('dir /T:W "%pct%" ^| findstr /R "^[0-9]"') do (
    rem Assume que o formato da data é DD/MM/YYYY
    set "dataModificacao=%%a %%b %%c %%d"  rem Captura DD/MM/YYYY HH:MM:SS
)

rem Reorganiza a data no formato AAAAMMDD HH:MM:SS
for /f "tokens=1,2,3 delims=/" %%d in ("!dataModificacao:~0,10!") do (
    set "dia=%%d"
    set "mes=%%e"
    set "ano=%%f"
    set "dataModificacao=!ano!!mes!!dia! !dataModificacao:~11!"  rem Concatena para formar AAAAMMDD HH:MM:SS
)

rem Comparar datas
if "!dataModificacao!" LSS "%dataComparacao%" (
    echo Inferior
) else (
    echo Okay
)

pause