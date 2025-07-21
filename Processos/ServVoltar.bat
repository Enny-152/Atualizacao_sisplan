@echo off
setlocal enabledelayedexpansion
color 0E

:VoltarServ5
echo --------------------------------------------------
set "voltaServico5="
echo Iniciando os servicos que contenham "Nginx" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Nginx"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico5!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico5=%%a"
    )
)


:VoltarServ1
echo --------------------------------------------------
set "voltaServico1="
echo Iniciando os servicos que contenham "Sisp" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Sisp"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico1!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico1=%%a"
    )
)


:VoltarServ2
echo --------------------------------------------------
set "voltaServico2="
echo Iniciando os servicos que contenham "Apache" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Apache"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico2!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico2=%%a"
    )
)


:VoltarServ3
echo --------------------------------------------------
set "voltaServico3="
echo Iniciando os servicos que contenham "FW7" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "FW7"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico3!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a >nul
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico3=%%a"
    )
)


:VoltarServ4
echo --------------------------------------------------
set "voltaServico4="
echo Iniciando os servicos que contenham "FSIS" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "FSIS"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico4!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico4=%%a"
    )
)


:VoltarServ6
echo --------------------------------------------------
set "voltaServico6="
echo Iniciando os servicos que contenham "_Api" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "_Api"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico6!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico6=%%a"
    )
)


:VoltarServ7
echo --------------------------------------------------
set "voltaServico7="
echo Iniciando os servicos que contenham "BuscaCTE" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "BuscaCTE"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico7!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico7=%%a"
    )
)


:VoltarServ8
echo --------------------------------------------------
set "voltaServico8="
echo Iniciando os servicos que contenham "Tomcat" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Tomcat"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico8!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico8=%%a"
    )
)

:VoltarServ9
echo --------------------------------------------------
set "voltaServico9="
echo Iniciando os servicos que contenham "RFID" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "RFID"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico9!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico9=%%a"
    )
)


:VoltarServ10
echo --------------------------------------------------
set "voltaServico10="
echo Iniciando os servicos que contenham "BuscarCTE" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "BuscarCTE"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico10!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico10=%%a"
    )
)


:VoltarServ11
echo --------------------------------------------------
set "voltaServico11="
echo Iniciando os servicos que contenham "BuscaNFE" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "BuscaNFE"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico11!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico11=%%a"
    )
)


:VoltarServ12
echo --------------------------------------------------
set "voltaServico12="
echo Iniciando os servicos que contenham "BuscarNFE" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "BuscarNFE"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico12!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico12=%%a"
    )
)

:VoltarServ13
echo --------------------------------------------------
set "voltaServico13="
echo Iniciando os servicos que contenham "API_Integra" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "API_Integra"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico13!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico13=%%a"
    )
)

:VoltarServ14
echo --------------------------------------------------
set "voltaServico14="
echo Iniciando os servicos que contenham "SOCIIS" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "SOCIIS"') do (
    rem Verifica se o servico já foi processado
    if "!voltaServico14!" neq "%%a" (
        echo Tentando iniciar o servico %%a...
        sc start %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "voltaServico14=%%a"
    )
)