@echo off
setlocal enabledelayedexpansion
color 0E

: POSTGRES    

set "attServico3="
    for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Postgres"') do (
    rem Verifica se o servico já foi processado
    if "!attServico3!" neq "%%a" (
        echo Tentando parar o servico %%a...
        psservice restart %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        echo --------------------------------------------------
        set "attServico3=%%a"
    )
    )


rem PARAR
set "attServico2="
    for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Postgres"') do (
    rem Verifica se o servico já foi processado
    if "!attServico2!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc start %%a >nul
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        echo --------------------------------------------------
        set "attServico2=%%a"
    )
    )

:: TEMPO
set Tempo=5
:ContagemRegressiva10
cls
echo Aguardando por !Tempo! segundos...
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem10
timeout /t 1 >nul
goto ContagemRegressiva10
:FimContagem10

rem VOLTAR
set "attServico2.1="
    for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Postgres"') do (
    rem Verifica se o servico já foi processado
    if "!attServico2.1!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a >nul
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        echo --------------------------------------------------
        set "attServico2.1=%%a"
    )
    )