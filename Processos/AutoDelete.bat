@echo off

:: Pega o caminho da pasta onde está o .bat
set "scriptDir=%~dp0"

:: Remove a barra invertida final, se houver
if "%scriptDir:~-1%"=="\" set "scriptDir=%scriptDir:~0,-1%"

:: Sobe duas pastas (de "Processos" para "DC", depois para "teste3")
for %%i in ("%scriptDir%\..\..") do set "baseDir=%%~fi"

:: Define o caminho completo da pasta "DC"
set "targetDir=%baseDir%\DC"

:: Confirma (opcional)
echo Apagando a pasta inteira: "%targetDir%"
:: pause

:: Aguarda 1 segundo antes de deletar a própria pasta
timeout /t 1 > nul

:: Remove a pasta DC inteira (inclusive este .bat)
rd /s /q "%targetDir%"
