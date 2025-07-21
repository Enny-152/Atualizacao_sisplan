@echo off
setlocal enabledelayedexpansion
color 0E

set Tempo=3
:ContagemRegressiva
cls
echo Aguardando por !Tempo! segundos...
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem
timeout /t 1 >nul
goto ContagemRegressiva
:FimContagem