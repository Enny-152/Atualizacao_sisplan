@echo off
setlocal enabledelayedexpansion
color 0E

:Service5
echo --------------------------------------------------
set "ultimoServico5="
echo Parando os servicos que contenham "Nginx" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Nginx"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico5!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico5=%%a"
    )
)

:Services1
echo --------------------------------------------------
set "ultimoServico1="
echo Parando os servicos que contenham "Sisp" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Sisp"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico1!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico1=%%a"
    )
)


:Services2
echo --------------------------------------------------
set "ultimoServico2="
echo Parando os servicos que contenham "Apache" no nome...
for /f "tokens=2 delims= " %%a in ('sc query state^= all ^| findstr /I "Apache"') do (
  if /i not "%%b"=="Apachelojaweb" (
    if not "!ultimoServico2!" neq "%%a" (
      echo Tentando parar o servico %%a...
      sc stop %%a
      echo Aguardando 3 segundos...
      timeout /t 3 /nobreak >nul
      set "ultimoServico2=%%a"
    )
  ) else (
    echo Servico %%b ignorado.
  )
)

:Services3
echo --------------------------------------------------
set "ultimoServico3="
echo Parando os servicos que contenham "FW7" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "FW7"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico3!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico3=%%a"
    )
)

:Services4
echo --------------------------------------------------
set "ultimoServico4="
echo Parando os servicos que contenham "FSIS" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "FSIS"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico4!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico4=%%a"
    )
)

:Services6
echo --------------------------------------------------
set "ultimoServico6="
echo Parando os servicos que contenham "_API" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "_API"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico6!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico6=%%a"
    )
)

:Services7
echo --------------------------------------------------
set "ultimoServico7="
echo Parando os servicos que contenham "BuscaCTE" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "BuscaCTE"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico7!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico7=%%a"
    )
)

:Services8
echo --------------------------------------------------
set "ultimoServico8="
echo Parando os servicos que contenham "Tomcat" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Tomcat"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico8!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico8=%%a"
    )
)

:Services9
echo --------------------------------------------------
set "ultimoServico9="
echo Parando os servicos que contenham "RFID" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "RFID"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico9!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico9=%%a"
    )
)

:Services10
echo --------------------------------------------------
set "ultimoServico10="
echo Parando os servicos que contenham "BuscarCTE" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "BuscarCTE"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico10!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico10=%%a"
    )
)

:Service11
echo --------------------------------------------------
set "ultimoServico11="
echo Parando os servicos que contenham "BuscaNFE" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "BuscaNFE"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico11!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico11=%%a"
    )
)

:Services12
echo --------------------------------------------------
set "ultimoServico12="
echo Parando os servicos que contenham "BuscarNFE" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "BuscarNFE"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico12!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico12=%%a"
    )
)

:Services13
echo --------------------------------------------------
set "ultimoServico13="
echo Parando os servicos que contenham "API_Integra" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "API_Integra"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico13!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico13=%%a"
    )
)

:Services14
echo --------------------------------------------------
set "ultimoServico14="
echo Parando os servicos que contenham "SOCIIS" no nome...
for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "SOCIIS"') do (
    rem Verifica se o servico já foi processado
    if "!ultimoServico14!" neq "%%a" (
        echo Tentando parar o servico %%a...
        sc stop %%a
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        set "ultimoServico14=%%a"
    )
)