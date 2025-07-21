@echo off
setlocal enabledelayedexpansion
color 0E

pause >nul

set "pct=C:\Sisplan\PctFaturamento.bpl"

for /f "tokens=1,2,3" %%a in ('dir /T:W "%pct%" ^| findstr /R "^[0-9]"') do (
    set dataModificacao=%%a %%b
)

echo A data do PCT atual %dataModificacao%

Pause >nul