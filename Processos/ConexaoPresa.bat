@echo off
setlocal enabledelayedexpansion
color 0E

:ConexaoPresa1
start "" "%Caminho%\cnxativos.exe"
set /p ConexaoPresa="Ha alguma conexao presa no banco de dados? Responda com S ou N: "
if /i "%ConexaoPresa%"=="N" (
    taskkill /f /im cnxativos.exe
    echo Nenhuma conexao presa encontrada. Continuando...
    cls
    goto Amem
)
if /i "%ConexaoPresa%"=="S" goto Escolhas
echo Resposta Invalida.
cls
goto ConexaoPresa1

:Escolhas
set /p Banco="Digite a inicial do banco de Dados! (F = Firebird / P = Postgres / O = Oracle / M = Mssql): "

if /i "%Banco%"=="F" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    set "attServico1="
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Firebird"') do (
    if not "%attServico1%"=="%%b" (
        echo Tentando parar o servico %%b...
        sc stop %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        set "attServico1=%%b"
    ) else (
      set "attServico1="
    )
    )
    set "attServico1.1="
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Firebird"') do (
    if not "%attServico1.1%"=="%%b" (
        echo Tentando iniciar o servico %%b...
        sc start %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        set "attServico1.1=%%b"
    ) else (
      set "attServico1.1="
    )
    )
    goto ConexaoPresa1
)
if /i "%Banco%"=="P" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    set "attServico2="
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Postgres"') do (
    if not "%attServico2%"=="%%b" (
        echo Tentando parar o servico %%b...
        sc stop %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        set "attServico2=%%b"
    ) else (
      set "attServico2="
    )
    )
    set "attServico2.1="
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Postgres"') do (
    if not "%attServico2.1%"=="%%b" (
        echo Tentando iniciar o servico %%b...
        sc start %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        set "attServico2.1=%%b"
    ) else (
      set "attServico2.1="
    )
    )
    goto ConexaoPresa1
)
if /i "%Banco%"=="M" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    timeout /t 5 >nul
    del /f "%Caminho%\Cnxativos.exe"
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    goto Amem
)
if /i "%Banco%"=="O" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    del /f "%Caminho%\Cnxativos.exe"
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    goto Amem
)
if /i "%Banco%"=="PP" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    del /f "%Caminho%\Cnxativos.exe"
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    set "attServico3="
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Postgres"') do (
        if not "%attServico3%"=="%%b" (
        echo Tentando parar o servico %%b...
        sc stop %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        set "attServico3=%%b"
    ) else (
      set "attServico3="
    )
    )
    set "attServico3.1="
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Postgres"') do (
        if not "%attServico3.1%"=="%%b" (
        echo Tentando iniciar o servico %%b...
        sc start %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        set "attServico3.1=%%b"
    ) else (
      set "attServico3.1="
    )
    )
    goto Amem
)
if /i "%Banco%"=="FF" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    del /f "%Caminho%\Cnxativos.exe"
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    set "attServico4="
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Firebird"') do (
        if not "%attServico4%"=="%%b" (
        echo Tentando parar o servico %%b...
        sc stop %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        set "attServico4=%%b"
    ) else (
      set "attServico4="
    )
    )
    set "attServico4.1="
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Firebird"') do (
        if not "%attServico4.1%"=="%%b" (
        echo Tentando iniciar o servico %%b...
        sc start %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        set "attServico4.1=%%b"
    ) else (
      set "attServico4.1="
    )
    )
    goto Amem
)
if /i "%Banco%"=="" (
    echo Banco invalido.
    goto ConexaoPresa1
)
echo Banco invalido.
goto ConexaoPresa1

:Amem