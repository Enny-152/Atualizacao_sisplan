@echo off
setlocal enabledelayedexpansion
color 0E

(
echo --------------------------------------------------------
echo             CREATED BY JULIO CESAR PEREIRA              
echo --------------------------------------------------------
echo.
echo VERSAO BAT 1.2411.19
echo.
)

set Tempo=3
:ContagemRegressivaEu
echo Aguardando por !Tempo! segundos...
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagemEu
timeout /t 1 >nul
goto ContagemRegressivaEu
:FimContagemEu


:: ----------------- ADMINISTRADOR -----------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERRO] Este script precisa ser executado como Administrador.
    echo Tentando reiniciar com privilegios de Administrador...
    timeout /t 3 /nobreak >nul
    rem Reinicia o script como Administrador
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dp0%~nx0' -Verb runAs"
    exit /b
)
color 0A
echo [OK] O script esta rodando como Administrador.
timeout /t 3 /nobreak >nul
cls


:: ----------------- PATH BAT -----------------
color 0F
rem Variável que define o caminho do Bat.
set bat=%~dp0
echo Caminho do bat %bat%
timeout /t 2 >nul


:: ----------------- USERS -----------------
:Users
echo Defina seu usuario e senha a seguir para executar os arquivos do Sisplan:
set /p User="Digite o usuario: "
set /p Senha="Digite a senha: "
cls
echo Usuario: %User%
echo Senha: %Senha%
echo.
set /p Uservalidador="Deseja prosseguir com essas credenciais? (S/N): "
if /i "%Uservalidador%"=="N" (
goto Users
)
if /i "%Uservalidador%"=="S" (
goto SolicitarCaminho
)
echo Resposta invalida!
goto Users


:: ----------------- PATH SISPLAN -----------------
:SolicitarCaminho
cls
color 0E
Set /p Caminho="Informe o caminho do Sisplan:"
if not exist "%Caminho%" (
    echo Caminho invalido. Por favor, tente novamente.
    goto SolicitarCaminho )

color 0F
set Tempo=3
:ContagemRegressiva
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2411.19
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem
timeout /t 1 >nul
goto ContagemRegressiva
:FimContagem


:: ----------------- INICIO -----------------
rem Captura o horário inicial
for /f "tokens=1,2 delims=:" %%a in ("%time%") do set "HoraInicio=%%a:%%b"


:: ----------------- PCT -----------------
:pct
cls
color 0D
set "pct=%Caminho%\PctFaturamento.bpl"
for /f "tokens=1,2,3" %%a in ('dir /T:W "%pct%" ^| findstr /R "^[0-9]"') do (
    set dataModificacao5=%%a %%b
)
echo A data do PCT atual %dataModificacao5%
timeout /t 5 >nul


:: ----------------- PARAMETROS -----------------
:Parametro
set "pct=%Caminho%\PctFaturamento.bpl"
set "dataComparacao=20240913 00:00:00"  rem Data de comparação no formato AAAAMMDD HH:MM:SS

rem Obtem a data de modificacao do arquivo
for /f "tokens=1,2,3,4" %%a in ('dir /T:W "%pct%" ^| findstr /R "^[0-9]"') do (
    rem Assume que o formato da data é DD/MM/YYYY
    set "dataModificacao=%%a %%b %%c %%d"  rem Captura DD/MM/YYYY HH:MM:SS
)

rem Reorganiza a data no formato AAAAMMDD HH:MM:SS
for /f "tokens=1,2,3 delims=/" %%d in ("!dataModificacao:~0,10!") do (
    set "dia=%%d"
    set "mes=%%e"
    set "ano=%%f"
    set "dataModificacao=!ano!!mes!!dia! !dataModificacao:~11!"  rem Concatena para formar AAAAMMDD HH:MM:SS
)
if "!dataModificacao!" LSS "%dataComparacao%" (
    set "resultado=alterar"
    cls
    color 0C
    echo -------------------------------------------------------------------------------------------
    echo [ATENCAO]
    echo PCT do cliente antecessor ao 13/09/2024 sera necessario inverter o parametro PRO, 240, 17
    echo Se tiver como 'S' colocar 'N', se tiver 'N' ou vazio colocar 'S'.
    pause
    goto Msgatualiza
) else (
    cls
    color 0A
    set "resultado=seguir"
    echo [OKAY]
    echo Sem alteracoes de parametros pendentes...
    timeout /t 3 >nul
    goto Msgatualiza
)


:: ----------------- MSGATUALIZA -----------------
if not exist "%Caminho%\MsgAtualiza.txt" (
goto MsgAtualiza
) else (
echo MsgAtualiza já está na pasta raiz, continuando...
goto IP
)

:Msgatualiza
color 0F
cls
echo Criando Msgatualiza na pasta raiz...
echo "Atualizacao iniciada em %date% %time%" > "%Caminho%\MsgAtualiza.txt"
echo Arquivo MsgAtualiza.txt criado com sucesso.
echo Sera aguardado 1 minuto para o MsgAtualiza funcionar.
timeout /t 3 >nul

set Tempo=60
:ContagemRegressiva1
cls
echo Aguardando por !Tempo! segundos...
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem1
timeout /t 1 >nul
goto ContagemRegressiva1
:FimContagem1


:: ----------------- IPVALIDADOR -----------------
:IP
set "ini=%Caminho%\Sisplan.ini"
set "banco="
set "ipini="

for /f "tokens=*" %%a in ('type "%ini%"') do (
    if not defined banco (
        echo %%a | findstr /i "banco=" >nul
        if !errorlevel! == 0 (
            set "linha=%%a"
            for /f "tokens=2 delims==" %%b in ("!linha!") do (
                set "banco=%%b"
            )
        )
    )
)

for /f "tokens=*" %%a in ('type "%ini%"') do (
    if not defined ipini (
        echo %%a | findstr /i "servidor=" >nul
        if !errorlevel! == 0 (
            set "linha=%%a"
            for /f "tokens=2 delims==" %%b in ("!linha!") do (
                set "ipini=%%b"
            )
        )
    )
)
set "ipServ=%ipini::=%"

rem Obter o IP atual do computador
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4"') do (
    for /f "tokens=1 delims= " %%j in ("%%i") do (
        set "ipLocal=%%j"
    )
)

if "%ipServ%"=="%ipLocal%" ( goto 1
) else (
goto 2
)

:1
cls
color 0A
echo Banco: %Banco%
echo.
echo Servidor: %ipServ%
echo Local: %ipLocal%
echo.
echo [OKAY]
echo Os IPs sao iguais, continuando a atualizacao sem problemas...
echo.
pause
goto Backups

:2
cls
color 0C
echo Banco: %Banco%
echo.
echo Servidor: %ipServ%
echo Local: %ipLocal%
echo.
echo [ATENCAO]
echo Os IPs sao diferentes, a base fica em outro lugar!
echo ----------------------------
echo Possiveis problemas
echo Conexoes e Arquivos Presos! 
echo Falta de backup (Firebird)! 
echo Sem acesso ao servicos da base!
echo.
pause
goto pah
 
:pah
cls
color 0F
set /p perigo="Deseja continuar mesmo assim? (S/N): "
if /i "%perigo%"=="S" goto Backups
if /i "%perigo%"=="N" (
echo Verifique possibilidade de conexão com a base...
del /f "%Caminho%\MsgAtualiza.txt"
goto SolicitarCaminho
)
echo Resposta Invalida.
goto pah


:: ----------------- BACKUP -----------------
:Backups
cls
color 0E
@echo off
rem Obter a data correta independentemente do formato regional
for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
    set Day=%%a
    set Month=%%b
    set Year=%%c
)

rem Ajustar a sequencia dependendo da ordem (para formatos DD/MM/YYYY ou MM/DD/YYYY)
if %Day% gtr 31 (
    :: Assumir formato YYYY-MM-DD
    set DataAtual=%Day%-%Month%-%Year%
) else (
    :: Assumir formato DD/MM/YYYY ou MM/DD/YYYY e inverter para YYYY-MM-DD
    set DataAtual=%Year%-%Month%-%Day%
)

rem Definir o caminho da pasta de backup
set PastaBackup=%Caminho%\Agora\BackupATT\Backup_%DataAtual%

rem Verificar se a pasta de backup ja existe
if exist "%PastaBackup%" (
    echo A pasta de backup ja existe, nao sera recriada.
    echo %PastaBackup%
    echo.
) else (
    rem Criar uma pasta com a data no formato YYYY-MM-DD
    mkdir "%PastaBackup%"
    echo Criando pasta de backup: %PastaBackup%

    rem Realizar o backup das pastas
    xcopy "%Caminho%\Relatorio" "%PastaBackup%\Relatorio" /E /I /Y >nul
    if exist "%PastaBackup%\Relatorio" echo Backup pasta Relatorio feito com sucesso!
    xcopy "%Caminho%\Layout" "%PastaBackup%\Layout" /E /I /Y >nul
    if exist "%PastaBackup%\Layout" echo Backup pasta Layout feito com sucesso!
    xcopy "%Caminho%\Sisinstala.exe" "%PastaBackup%\" >nul
    if exist "%PastaBackup%\Sisinstala.exe" echo Backup do Sisinstala.exe feito com sucesso!
    xcopy "%Caminho%\Base" "%PastaBackup%\Base" /E /I /Y >nul
    if exist "%PastaBackup%\Base" echo Backup pasta Base feito com sucesso!
    echo Backup das pastas concluido.
    echo.

    rem Registrar a data e hora de inicio do backup
    echo "Atualizacao iniciada em %date% %time%" > "%PastaBackup%\Inicio_%DataAtual%.txt"
)

:Conferencia
set /p resposta="Backup foi realizado corretamente? "%PastaBackup%" (S/N): "
if /i "%resposta%"=="S" (
echo Show de Bola!
echo.
goto ServParar
)
if /i "%resposta%"=="N" (
echo Faca o Backup Manualmente.
echo.
goto Conferencia
)
if /i "%resposta%"=="" (
echo Resposta invalida. Tente novamente.
goto Conferencia
)
echo Resposta invalida. Tente novamente.
goto Conferencia


:: ----------------- SERVICOS PARAR -----------------
:ServParar
call :RunAsAdmin "%Bat%Processos\ServParar.bat"
:RunAsAdmin
powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
echo Todos os servicos foram processados.
pause


:: ----------------- TEMPO -----------------
color 0F
set Tempo=3
:ContagemRegressiva2
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2411.19
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem2
timeout /t 1 >nul
goto ContagemRegressiva2
:FimContagem2


:: ----------------- CONEXÕES PRESAS -----------------
:ConexaoPresa1
cls
color 0E
if exist "%Caminho%\cnxativos.exe" (
start "" "%Caminho%\cnxativos.exe"
goto Xeso
) else (
echo CnxAtivos Deletado ou Inexistente!
goto Xeso
)

:Xeso
echo Banco: %Banco%
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
set /p BancoPreso="Digite a inicial do banco de Dados! : (F = Firebird / P = Postgres / O = Oracle / M = Mssql):"

if /i "%BancoPreso%"=="F" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    xcopy "%bat%Utilitarios\PSTools\PsService.exe" "%SystemRoot%\System32" /E /I /Y
    xcopy "%bat%Utilitarios\PSTools\PsService64.exe" "%SystemRoot%\System32" /E /I /Y >nul
    call :RunAsAdmin1 "%Bat%Processos\BancoFirebird.bat"
    :RunAsAdmin1
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
    pause
    goto ConexaoPresa1
)
if /i "%BancoPreso%"=="P" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    xcopy "%bat%Utilitarios\PSTools\PsService.exe" "%SystemRoot%\System32" /E /I /Y
    xcopy "%bat%Utilitarios\PSTools\PsService64.exe" "%SystemRoot%\System32" /E /I /Y >nul
    call :RunAsAdmin2 "%Bat%Processos\BancoPostgres.bat"
    :RunAsAdmin2
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
    pause
    goto ConexaoPresa1
)
if /i "%BancoPreso%"=="M" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    timeout /t 5 >nul
    del /f "%Caminho%\Cnxativos.exe"
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    goto Amem
)
if /i "%BancoPreso%"=="O" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    del /f "%Caminho%\Cnxativos.exe"
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    goto Amem
)
if /i "%BancoPreso%"=="PP" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    xcopy "%bat%Utilitarios\PSTools\PsService.exe" "%SystemRoot%\System32" /E /I /Y
    xcopy "%bat%Utilitarios\PSTools\PsService64.exe" "%SystemRoot%\System32" /E /I /Y >nul
    del /f "%Caminho%\Cnxativos.exe"
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    call :RunAsAdmin3 "%Bat%Processos\BancoPostgres.bat"
    :RunAsAdmin3
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
    goto Amem
)
if /i "%BancoPreso%"=="FF" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    xcopy "%bat%Utilitarios\PSTools\PsService.exe" "%SystemRoot%\System32" /E /I /Y
    xcopy "%bat%Utilitarios\PSTools\PsService64.exe" "%SystemRoot%\System32" /E /I /Y >nul
    del /f "%Caminho%\Cnxativos.exe"
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    call :RunAsAdmin4 "%Bat%Processos\BancoFirebird.bat"
    :RunAsAdmin4
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
    goto Amem
)
if /i "%BancoPreso%"=="" (
    echo Banco invalido.
    goto ConexaoPresa1
)

echo Banco invalido.
goto ConexaoPresa1
:Amem


:: ----------------- TEMPO -----------------
color 0F
set Tempo=3
:ContagemRegressiva3
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2411.19
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem3
timeout /t 1 >nul
goto ContagemRegressiva3
:FimContagem3


:: ----------------- FECHAR ARQUIVOS -----------------
color 0B
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


:: ----------------- TEMPO -----------------
color 0F
set Tempo=3
:ContagemRegressiva4
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2411.19
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem4
timeout /t 1 >nul
goto ContagemRegressiva4
:FimContagem4


:: ----------------- ATUALIZADOR -----------------
rem Criar o arquivo VBS dinamicamente
echo Criando script VBS...

(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.Run """%Caminho%\Atualizador.exe"""
echo WScript.Sleep 2000
echo WshShell.SendKeys "%user%"
echo WshShell.SendKeys "{TAB}"
echo WshShell.SendKeys "%senha%"
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

:: ----------------- TEMPO -----------------
color 0F
set Tempo=5
:ContagemRegressiva5
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2411.19
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem5
timeout /t 1 >nul
goto ContagemRegressiva5
:FimContagem5


:: ----------------- VALIDADOR ATT -----------------
:Senpai
set /p baka="Problemas com a atualizacao? (S/N): "
if /i "%baka%"=="S" goto Loli
if /i "%baka%"=="N" goto Yahallo
echo Repito a pergunta!
goto Senpai

:Loli
set /p lol="Iniciar o Sisinstala? (S/N): "
if /i "%lol%"=="S" (
start "" "%Caminho%\Sisinstala.exe
goto Senpai
)
if /i "%lol%"=="N" goto ConexaoPresa1
echo Repito a pergunta!
goto Loli


:: ----------------- SERVICOS VOLTAR -----------------
:Yahallo
color 0E
set /p putamerda="Voltar os Servicos? (S/N): "
if /i "%putamerda%"=="S" (
    goto VoltarServicos
)
if /i "%putamerda%"=="N" (
    echo Okay!
    goto Finaliza
)
echo Decida-se!
goto Yahallo

:VoltarServicos
echo Iniciando os servicos...
call :RunAsAdmin5 "%Bat%Processos\ServVoltar.bat"
:RunAsAdmin5
powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
echo Todos os servicos foram processados.
pause


:: ----------------- TEMPO -----------------
color 0F
set Tempo=3
:ContagemRegressiva6
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2411.19
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem6
timeout /t 1 >nul
goto ContagemRegressiva6
:FimContagem6



:: ----------------- COMPLETE ----------------
cls
color 0B
for /f %%A in ('powershell -Command "$env:user.ToUpper()"') do set "user=%%A"
for /f "tokens=1,2 delims=:" %%a in ("%time%") do set "HoraFim=%%a:%%b"
set "pct2=%Caminho%\PctFaturamento.bpl"
for /f "tokens=1,2,3" %%a in ('dir /T:W "%pct%" ^| findstr /R "^[0-9]"') do (
    set dataModificacao6=%%a %%b
)
timeout /t 5 >nul
echo BOM TRABALHO.
echo TECNICO RESPONSAVEL: %User% > "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Complete.txt"
echo VERSAO PCT: %dataModificacao6% (OFICIAL) >> "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Complete.txt"
echo INICIO ATT: %HoraInicio% >> "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Complete.txt"
echo FIM ATT: %HoraFim% >> "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Complete.txt"
echo. >> "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Complete.txt"
echo - VERIFICADO SE EXCLUIU O MSGATUALIZA.TXT DA RAIZ DO SISPLAN; >> "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Complete.txt"
echo - ATUALIZADO PARAMETROS E CONSULTADO OS MENUS DO SISTEMA; >> "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Complete.txt"
echo - INICIADO OS SERVICOS QUE FORAM PARADOS; >> "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Complete.txt"
echo - COMPACTADO O BACKUP; >> "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Complete.txt"
echo.


:: ----------------- FIM ----------------
:Finaliza
cls
color 0B
echo BOM TRABALHO.
echo "Atualizacao finalizada em %date% %time%" > "%Caminho%\Agora\BackupATT\Backup_%DataAtual%\Fim_%DataAtual%.txt"
echo.


:: ----------------- COMPLETE ----------------

(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.Run """%Caminho%\Sisplan.exe"""
echo WScript.Sleep 10000
echo WshShell.SendKeys "{TAB}"
echo WshShell.SendKeys "%senha%"
echo WshShell.SendKeys "{ENTER}"
echo WScript.Sleep 2000
echo WshShell.SendKeys "{DELETE}"
echo WshShell.SendKeys "Sisplan.%user%"
echo WScript.Sleep 2000
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
) > temp.vbs

rem Executar o script VBS
start temp.vbs
rem Esperar 5 segundos e deletar o arquivo VBS temporario
timeout /t 5 >nul
del temp.vbs

echo Script finalizado.
pause
exit

