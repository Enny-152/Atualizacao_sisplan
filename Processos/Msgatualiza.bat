@echo off
setlocal enabledelayedexpansion
color 0E

echo Criando Msgatualiza na pasta raiz...
echo "Atualizacao iniciada em %date% %time%" > "%Caminho%\MsgAtualiza.txt"
echo Arquivo MsgAtualiza.txt criado com sucesso.
echo Sera aguardado 1 minuto para o MsgAtualiza funcionar.
timeout /t 3 >nul

set Tempo=60
:ContagemRegressiva1
cls
echo Aguardando por !Tempo! segundos...
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem1
timeout /t 1 >nul
goto ContagemRegressiva1
:FimContagem1
