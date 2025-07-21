@echo off
setlocal enabledelayedexpansion
color 0E

rem Executar o script VBS
start temp.vbs
rem Esperar 5 segundos e deletar o arquivo VBS temporario
timeout /t 5 >nul
del temp.vbs

start /b cmd /c "del %~f0"
echo Script finalizado.