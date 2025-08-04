@echo off
setlocal enabledelayedexpansion
color 0E

rem Obtém a lista de arquivos abertos e exibe
echo Listando arquivos abertos:
net file

rem Desconectar arquivos abertos
for /f "tokens=1" %%i in ('net file ^| findstr /R "^[0-9]"') do (
    echo.
    echo Tentando desconectar o arquivo com ID %%i...
    net file %%i /close
    if errorlevel 1 (
        echo Falha ao desconectar o arquivo com ID %%i. Tentando forcar a desconexao...

        rem Tenta forcar a desconexao
        for /f "tokens=3" %%j in ('net file %%i') do (
            echo Forcando o encerramento do processo com ID %%j...
            taskkill /PID %%j /F >nul 2>&1
            if errorlevel 1 (
                echo Falha ao forcar o encerramento do processo com ID %%j.
            ) else (
                echo Processo com ID %%j encerrado com sucesso. Tentando desconectar novamente...
                net file %%i /close
            )
        )
    ) else (
        echo Arquivo com ID %%i desconectado com sucesso.
    )
)
echo.
echo Processo de desconexao concluido.

:Conex1
set /p Conexao="Processo anterior para fechar os arquivos abertos funcionou? Responda com 'S' ou 'N': "
if /i "%Conexao%"=="N" (
    echo Executando o Gerenciamento do Computador. Clique em Pastas Compartilhadas e, com o botao direito nos Arquivos Abertos, clique em "Desconectar todos os arquivos abertos".
    start "" "C:\Windows\System32\compmgmt.msc"
    timeout /t 15 >nul
    taskkill /f /im "mmc.exe"
    goto Okay
)
if /i "%Conexao%"=="S" (
    echo Show de BOLA.
    goto Okay
)
echo Resposta Invalida.
goto Conex1

:Okay