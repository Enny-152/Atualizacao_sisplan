@echo off
setlocal enabledelayedexpansion
color 0E

rem Criar o arquivo VBS dinamicamente
echo Criando script VBS...

(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.Run """%Caminho%\Atualizador.exe"""
echo WScript.Sleep 2000
echo WshShell.SendKeys "Julio.Pereira"
echo WshShell.SendKeys "{TAB}"
echo WshShell.SendKeys "Kana$007"
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
) > temp.vbs

rem Executar o script VBS
start temp.vbs
rem Esperar 5 segundos e deletar o arquivo VBS temporario
timeout /t 5 >nul
del temp.vbs

set "Atualizador=Atualizador.exe"
tasklist | findstr /I "%Atualizador%" >nul
if %errorlevel%==0 (
    echo O processo %Atualizador% esta em execucao.
    goto Kohai
) else (
    echo O processo %Atualizador% nao esta em execucao.
    echo Iniciando...
    start "" "%Caminho%\Atualizador.exe"
    goto Kohai
)
:Kohai
