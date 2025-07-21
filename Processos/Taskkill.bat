@echo off
setlocal enabledelayedexpansion
color 0E

set "maquinaRemota=172.20.20.145"  :: IP da máquina remota
set "servico=Sisp"         :: Nome do serviço que você deseja parar e iniciar
set "portaRPC=135"                  :: Porta do RPC (Remote Procedure Call)

echo Verificando se a porta %portaRPC% está aberta na máquina remota %maquinaRemota%...

:: Testa a conectividade com a porta 135 (RPC)
telnet %maquinaRemota% %portaRPC%
if %errorlevel%==0 (
    echo A porta %portaRPC% está aberta. O firewall permite controle remoto.

    echo Tentando parar o serviço %servico% na máquina remota...
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Firebird"') do (
        echo Tentando parar o servico %%b...
        sc \\%maquinaRemota% stop %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        echo --------------------------------------------------
    )
    if %errorlevel%==0 (
        echo O serviço %servico% foi parado com sucesso.
    ) else (
        echo Falha ao parar o serviço %servico%.
    )

    echo Aguardando 3 segundos...
    timeout /t 3 /nobreak >nul

    echo Tentando iniciar o serviço %servico% na máquina remota...
    for /f "tokens=1,2 delims= " %%a in ('sc query state^= all ^| findstr /I "Firebird"') do (
        echo Tentando parar o servico %%b...
        sc \\%maquinaRemota% stop %%b
        echo Aguardando 5 segundos...
        timeout /t 5 /nobreak >nul
        echo --------------------------------------------------
    ) 
    if %errorlevel%==0 (
        echo O serviço %servico% foi iniciado com sucesso.
    ) else (
        echo Falha ao iniciar o serviço %servico%.
    )
) else (
    echo A porta %portaRPC% está fechada ou o firewall está bloqueando conexões remotas.
)

pause
