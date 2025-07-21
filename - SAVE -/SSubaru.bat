@echo off
setlocal enabledelayedexpansion
color 0E

(
echo --------------------------------------------------------
echo             CREATED BY JULIO CESAR PEREIRA              
echo --------------------------------------------------------
echo.
echo VERSAO BAT 1.2412.3
echo.
)

set Tempo=3
:ContagemRegressiva
echo Aguardando por !Tempo! segundos...
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem
timeout /t 1 >nul
goto ContagemRegressiva
:FimContagem


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


:: ----------------- PATH DOWNLOADS -----------------
:Downloads
cls
color 0F
set "ProgramFiles=%ProgramFiles%"
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "[environment]::GetFolderPath('MyDocuments').replace('Documents','Downloads')"') do set "DownloadsFolder=%%i"
echo Pasta de Downloads: %DownloadsFolder%
echo ----------------------------------------------------------


:: ----------------- PATH BAT -----------------
:SolicitarCaminho
rem Variável que define o caminho do Bat.
set bat=%~dp0
echo Caminho do bat: %bat%
echo ----------------------------------------------------------


:: ----------------- PATH SISPLAN -----------------
set /p Caminho="Informe o caminho do Sisplan: "
if not exist "%Caminho%" (
    echo Caminho invalido. Por favor, tente novamente.
    goto SolicitarCaminho )

color 0F
set Tempo=3
:ContagemRegressiva1
cls
echo VERSAO BAT 1.2412.3
echo A atualizacao esta sendo executada no caminho %Caminho%
echo.
echo Aguardando por !Tempo! segundos...
echo.
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
goto 7Zip

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
if /i "%perigo%"=="S" goto 7Zip
if /i "%perigo%"=="N" (
echo Verifique possibilidade de conexão com a base...
del /f "%Caminho%\MsgAtualiza.txt"
exit
)
echo Resposta Invalida.
goto pah


:: ----------------- 7-ZIP -----------------
:7Zip
set "SevenZipPath=%ProgramFiles%\7-Zip\7z.exe"
if not exist SevenZipPath (
    echo 7-Zip encontrado em: %SevenZipPath%
    goto Users
) else (
    echo 7-Zip não está instalado ou não foi encontrado.
    start "" "%bat%Utilitarios\7z2407-x64.exe"
    pause
    goto Users
)

:: ----------------- USERS -----------------
:Users
cls
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
goto Msgatualiza
)
echo Resposta invalida!
goto Users


:: ----------------- MSGATUALIZA -----------------
:Msgatualiza
cls
color 0F
echo Criando Msgatualiza na pasta raiz...
echo "Atualizacao iniciada em %date% %time%" > "%Caminho%\MsgAtualiza.txt"
echo Arquivo MsgAtualiza.txt criado com sucesso.
echo Sera aguardado 1 minuto para o MsgAtualiza funcionar.

set Tempo=2
:ContagemRegressiva2
cls
echo A atualizacao esta sendo executada no caminho %Caminho%
echo Aguardando por !Tempo! segundos...
echo.
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem2
timeout /t 1 >nul
goto ContagemRegressiva2
:FimContagem2


:: ----------------- PROCEDIMENTO -----------------
:Procedimento
cls
color 0F
echo ##################################
echo             PROCESSOS!            
echo ##################################
echo.
echo (Atualizar o ERP = E)
echo (Atualizar o WEB = W)
echo (Reparacao de Base = RB)
echo (Estrutura de Base = EB)
echo (Convercao de Base = CB)
echo (Finalizar = F)
echo.
echo +++ Qual processo sera realizado no sistema? +++
set /p Procedimento= "Resposta: "

:SavePoint
if /i "%Procedimento%"=="F" (
echo Bom Trabalho!
echo.
if exist "%Caminho%\MsgAtualiza.txt" (
del /f "%Caminho%\MsgAtualiza.txt"
)
pause
exit
)
if /i "%Procedimento%"=="E" (
echo Atualizacao ERP
timeout /t 3 /nobreak >nul
cls
if not exist "%Caminho%\MsgAtualiza.txt" (
goto MsgAtualiza
) else (
goto ERP
  )
)
if /i "%Procedimento%"=="W" (
echo Atualizacao WEB
timeout /t 3 /nobreak >nul
cls
if not exist "%Caminho%\MsgAtualiza.txt" (
goto MsgAtualiza
) else (
goto WEB
  )
)
if /i "%Procedimento%"=="RB" (
echo Reparacao de Base
timeout /t 3 /nobreak >nul
cls
if not exist "%Caminho%\MsgAtualiza.txt" (
goto MsgAtualiza
) else (
goto REPARA
  )
)
if /i "%Procedimento%"=="EB" (
echo Estrutura de Base
timeout /t 3 /nobreak >nul
cls
if not exist "%Caminho%\MsgAtualiza.txt" (
goto MsgAtualiza
) else (
goto ESTRUTURA
  )
)
if /i "%Procedimento%"=="CB" (
echo Conversao de Base
timeout /t 3 /nobreak >nul
cls
if not exist "%Caminho%\MsgAtualiza.txt" (
goto MsgAtualiza
) else (
goto CONVERSAO
  ) 
)
cls
goto Procedimento


:: ******************************************************************** ERP ********************************************************************
:ERP

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
    goto Backups
) else (
    cls
    color 0A
    set "resultado=seguir"
    echo [OKAY]
    echo Sem alteracoes de parametros pendentes...
    timeout /t 3 >nul
    goto Backups
)


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
    xcopy "%Caminho%\Relatorio" "%PastaBackup%\Relatorio" /E /I /Y
    if exist "%PastaBackup%\Relatorio" echo Backup pasta Relatorio feito com sucesso!
    xcopy "%Caminho%\Layout" "%PastaBackup%\Layout" /E /I /Y
    if exist "%PastaBackup%\Layout" echo Backup pasta Layout feito com sucesso!
    xcopy "%Caminho%\Base" "%PastaBackup%\Base" /E /I /Y
    if exist "%PastaBackup%\Base" echo Backup pasta Base feito com sucesso!
    echo Backup das pastas concluido.
    echo.

    rem Registrar a data e hora de inicio do backup
    echo "Atualizacao iniciada em %date% %time%" > "%PastaBackup%\Inicio_%DataAtual%.txt"
)

:Conferencia
cls
echo "%PastaBackup%"
set /p resposta="Backup foi realizado corretamente? (S/N): "
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
cls
echo Parando Servicos...
echo.
call :RunAsAdmin "%Bat%Processos\ServParar.bat"
:RunAsAdmin
powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
echo Espere que todos os servicos sejam processados.
pause


:: ----------------- TEMPO -----------------
color 0F
set Tempo=3
:ContagemRegressiva3
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2412.3
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem3
timeout /t 1 >nul
goto ContagemRegressiva3
:FimContagem3


:: ----------------- CONEXÕES PRESAS -----------------
:ConexaoPresa1
cls
color 0E
if exist "%Caminho%\cnxativos.exe" (
start "" "%Caminho%\cnxativos.exe"
goto Xeso
) else (
echo ####################################
echo  CNXATIVOS DELETADO OU INEXISTENTE!
echo ####################################
goto Xeso
)

:Xeso
echo Banco: %Banco%
set /p ConexaoPresa="Ha alguma conexao presa no banco de dados? Responda com S ou N :"
if /i "%ConexaoPresa%"=="N" (
    taskkill /f /im cnxativos.exe
    echo Nenhuma conexao presa encontrada. Continuando...
    cls
    goto Amem
)
if /i "%ConexaoPresa%"=="S" goto Escolhas
echo Resposta Invalida.
cls
goto Xeso

:Escolhas
echo.
echo (F = Firebird / P = Postgres / O = Oracle / M = Mssql)
set /p BancoPreso="Digite a inicial do banco de Dados: "
echo.
if /i "%BancoPreso%"=="F" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    set "attServico11="
    for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Firebird"') do (
    rem Verifica se o servico já foi processado
    if "!attServico11!" neq "%%a" (
        echo Tentando parar o servico %%a...
        powershell -Command "Restart-Service -Name '%%a'"
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        echo --------------------------------------------------
        set "attServico11=%%a"
    )
    )
    if %errorlevel% neq	0 (
    xcopy "%bat%Utilitarios\PSTools\PsService.exe" "%SystemRoot%\System32" /E /I /Y
    xcopy "%bat%Utilitarios\PSTools\PsService64.exe" "%SystemRoot%\System32" /E /I /Y >nul
    call :RunAsAdmin1 "%Bat%Processos\BancoFirebird.bat"
    :RunAsAdmin1
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
    pause
    goto ConexaoPresa1
    ) else (
    goto ConexaoPresa1
)
if /i "%BancoPreso%"=="P" (
    taskkill /f /im sisplan.exe
    taskkill /f /im cnxativos.exe
    set "attServico12="
    for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Postgres"') do (
    rem Verifica se o servico já foi processado
    if "!attServico12!" neq "%%a" (
        echo Tentando parar o servico %%a...
        powershell -Command "Restart-Service -Name '%%a'"
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        echo --------------------------------------------------
        set "attServico12=%%a"
    )
    )
    if %errorlevel% neq	0 (
    xcopy "%bat%Utilitarios\PSTools\PsService.exe" "%SystemRoot%\System32" /E /I /Y
    xcopy "%bat%Utilitarios\PSTools\PsService64.exe" "%SystemRoot%\System32" /E /I /Y >nul
    call :RunAsAdmin2 "%Bat%Processos\BancoPostgres.bat"
    :RunAsAdmin2
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
    pause
    goto ConexaoPresa1
    ) else (
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
    taskkill /f /im cnxativos.exe
    taskkill /f /im sisplan.exe
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    del /f "%Caminho%\Cnxativos.exe"
    set "attServico13="
    for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Postgres"') do (
    rem Verifica se o servico já foi processado
    if "!attServico13!" neq "%%a" (
        echo Tentando parar o servico %%a...
        powershell -Command "Restart-Service -Name '%%a'"
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        echo --------------------------------------------------
        set "attServico13=%%a"
    )
    )
    if %errorlevel% neq	0 (
    xcopy "%bat%Utilitarios\PSTools\PsService.exe" "%SystemRoot%\System32" /E /I /Y
    xcopy "%bat%Utilitarios\PSTools\PsService64.exe" "%SystemRoot%\System32" /E /I /Y >nul
    call :RunAsAdmin3 "%Bat%Processos\BancoPostgres.bat"
    :RunAsAdmin3
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
    goto Amem
    ) else (
    goto Amem
)
if /i "%BancoPreso%"=="FF" (
    taskkill /f /im cnxativos.exe
    taskkill /f /im sisplan.exe
    del /f "%Caminho%\sisplan_novo\dependencias\Cnxativos.exe"
    del /f "%Caminho%\Cnxativos.exe"
    set "attServico14="
    for /f "tokens=2 delims=: " %%a in ('sc query state^= all ^| findstr /I "Firebird"') do (
    rem Verifica se o servico já foi processado
    if "!attServico14!" neq "%%a" (
        echo Tentando parar o servico %%a...
        powershell -Command "Restart-Service -Name '%%a'"
        echo Aguardando 3 segundos...
        timeout /t 3 /nobreak >nul
        echo --------------------------------------------------
        set "attServico14=%%a"
    )
    )
    if %errorlevel% neq	0 (
    xcopy "%bat%Utilitarios\PSTools\PsService.exe" "%SystemRoot%\System32" /E /I /Y
    xcopy "%bat%Utilitarios\PSTools\PsService64.exe" "%SystemRoot%\System32" /E /I /Y >nul
    call :RunAsAdmin4 "%Bat%Processos\BancoFirebird.bat"
    :RunAsAdmin4
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
    goto Amem
    ) else (
    goto Amem
)
if /i "%Banco%"=="" (
    echo Banco invalido.
    goto ConexaoPresa1
)

echo Banco invalido.
goto ConexaoPresa1
:Amem


:: ----------------- TEMPO -----------------
color 0F
set Tempo=3
:ContagemRegressiva4
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2412.3
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem4
timeout /t 1 >nul
goto ContagemRegressiva4
:FimContagem4


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
:ContagemRegressiva5
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2412.3
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem5
timeout /t 1 >nul
goto ContagemRegressiva5
:FimContagem5


:: ----------------- ATUALIZADOR -----------------
rem Criar o arquivo VBS dinamicamente
echo Criando script VBS...

(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.Run """%Caminho%\Atualizador.exe"""
echo WScript.Sleep 3000
echo WshShell.SendKeys "%Usuario%"
echo WshShell.SendKeys "{TAB}"
echo WshShell.SendKeys "%Senha%"
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
:ContagemRegressiva6
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2412.3
echo A atualizacao esta sendo executada no caminho %Caminho%
set /a Tempo-=1
if !Tempo! lss 0 goto FimContagem6
timeout /t 1 >nul
goto ContagemRegressiva6
:FimContagem6


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
echo Espere que todos os servicos sejam processados.
pause


:: ----------------- TEMPO -----------------
color 0F
set Tempo=3
:ContagemRegressiva6
cls
echo Aguardando por !Tempo! segundos...
echo.
echo VERSAO BAT 1.2412.3
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

(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.Run """%Caminho%\Sisplan.exe"""
echo WScript.Sleep 10000
echo WshShell.SendKeys "{TAB}"
echo WshShell.SendKeys "%Senha%"
echo WshShell.SendKeys "{ENTER}"
echo WScript.Sleep 2000
echo WshShell.SendKeys "{DELETE}"
echo WshShell.SendKeys "Sisplan.%Usuario%"
echo WScript.Sleep 2000
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
) > temp.vbs

rem Executar o script VBS
start temp.vbs
rem Esperar 10 segundos e deletar o arquivo VBS temporario
timeout /t 10 >nul
del temp.vbs

echo Script ERP finalizado.
pause
goto Procedimento


:: ******************************************************************** WEB ********************************************************************
:WEB

:: ----------------- CAMINHO APACHE24 -----------------
:WayApache24
cls
color 0F
set /p Apache24="Informe o caminho do Apache24 do web (Sem a pasta "HTDOCS"): "
if not exist "%Apache24%" (
    echo Caminho invalido. Por favor, tente novamente.
    goto WayApache24
)


:: ----------------- VERSAO WEB -----------------
:VersaoWeb
echo.
for /f "tokens=1,2 delims=:" %%a in ("%time%") do set "HoraInicioWeb=%%a:%%b"

set "Webini=%Caminho%\ApiWeb.ini"
set "Webversion="

for /f "tokens=*" %%a in ('type "%Webini%"') do (
    if not defined Webversion (
        echo %%a | findstr /i "versao=" >nul
        if !errorlevel! == 0 (
            set "linha=%%a"
            for /f "tokens=2 delims==" %%b in ("!linha!") do (
                set "Webversion=%%b"
            )
        )
    )
)
echo Versao do Web Atual:
echo %Webversion%
echo.
timeout /t 3 >nul


:: ----------------- SERVICOS PARAR -----------------
:ServPararWeb
cls
call :RunAsAdmin6 "%Bat%Processos\ServParar.bat"
:RunAsAdmin6
powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
echo Espere que todos servicos sejam processados.
echo.
pause


:: ----------------- BACKUP -----------------
:BackupsWEB
cls
color 0E
echo Comecando Backups de arquivos WEB.
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
set PastaBackupWeb=%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%

rem Verificar se a pasta de backup ja existe
if exist "%PastaBackupWeb%" (
    echo A pasta de backup ja existe, nao sera recriada.
    echo %PastaBackupWeb%
    echo.
) else (
    rem Criar uma pasta com a data no formato YYYY-MM-DD
    mkdir "%PastaBackupWeb%"
    echo Criando pasta de backup: %PastaBackupWeb%
    rem Realizar o backup das pastas
    xcopy "%Apache24%\htdocs\Sisplan_web" "%PastaBackupWeb%\Sisplan_web" /E /I /Y >nul
    if exist "%PastaBackupWeb%\Sisplan_web" echo Backup da pasta Sisplan_web feito com sucesso!
    xcopy "%Caminho%\Apiweb.exe" "%PastaBackupWeb%\" >nul
    if exist "%PastaBackupWeb%\Apiweb.exe" echo Backup Apiweb.exe feito com sucesso!
    xcopy "%Caminho%\Apiweb.map" "%PastaBackupWeb%\" >nul
    if exist "%PastaBackupWeb%\Apiweb.map" echo Backup Apiweb.map feito com sucesso!
    xcopy "%Caminho%\Apilocal.exe" "%PastaBackupWeb%\" >nul
    if exist "%PastaBackupWeb%\Apilocal.exe" echo Backup Apilocal.exe feito com sucesso!
    xcopy "%Caminho%\Apilocal.map" "%PastaBackupWeb%\" >nul
    if exist "%PastaBackupWeb%\Apilocal.map" echo Backup Apilocal.map feito com sucesso!
    xcopy "%Caminho%\Apiweb.ini" "%PastaBackupWeb%\" >nul
    if exist "%PastaBackupWeb%\Apiweb.ini" echo Backup Apiweb.ini feito com sucesso!
    xcopy "%Caminho%\Estrutura_api" "%PastaBackupWeb%\Estrutura_api" /E /I /Y >nul
    if exist "%PastaBackupWeb%\Estrutura_api" echo Backup da pasta Estrutura_api feito com sucesso!
    echo Backup dos arquivos concluido.
    echo.

    rem Registrar a data e hora de inicio do backup
    echo "Atualizacao iniciada em %date% %time%" > "%PastaBackupWeb%\Inicio_%DataAtual%.txt"
)

if exist "%Apache24%\htdocs\sisplan_web_old" (
echo.
echo Deletar a pasta "Sisplan_web_old"...
del /f "%Apache24%\htdocs\sisplan_web_old"
goto ConferenciaWeb
) else (
echo.
echo Pasta Sisplan_web_old inexistente, continuando atualizacao.
goto ConferenciaWeb
)

:ConferenciaWeb
cls
echo "%PastaBackupWeb%"
set /p respostaweb="Backup foi realizado corretamente? (S/N): "
if /i "%respostaweb%"=="S" (
echo Show de Bola!
echo.
goto DownloadWeb
)
if /i "%respostaweb%"=="N" (
echo Faca o Backup Manualmente.
echo.
goto ConferenciaWeb
)
if /i "%respostaweb%"=="" (
echo Resposta invalida. Tente novamente.
goto ConferenciaWeb
)
echo Resposta invalida. Tente novamente.
goto ConferenciaWeb


:: ----------------- LINK DOWNLOAD -----------------
:DownloadWeb
cls
echo Verificando Pasta do Atualizador WEB!
if not exist "%Caminho%\Atualizador_sisplan_web" (
  if exist "%DownloadsFolder%\atualizador_sisplan_web.zip" (
  echo.
  echo DELETAR A PASTA ATUALIZADOR_SISPLAN_WEB DOS DOWNLOADS.
  echo.
  del /f "%DownloadsFolder%\atualizador_sisplan_web.zip"
  )
  if exist "%DownloadsFolder%\atualizador_sisplan_web" (
  echo DELETAR A PASTA ATUALIZADOR_SISPLAN_WEB DOS DOWNLOADS.
  echo.
  del /f "%DownloadsFolder%\atualizador_sisplan_web"
  )
  echo Realizando Download da pasta do Atualizador Web!
  timeout /t 5 >nul
  start https://github.com/Sisplan-Sistemas/atualizador_sisplan_web/releases/download/1.1.4/atualizador_sisplan_web.zip
  pause
  7z x "%DownloadsFolder%\atualizador_sisplan_web.zip" -o"%Caminho%"
  pause
  goto AtualizadorWeb
) else (
echo. 
echo Raiz ja possui o Atulizador Loja Web! Continuando...
goto AtualizadorWeb
)


:: ----------------- ATUALIZADOR -----------------
:Testes3
(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.Run """%Caminho%\atualizador_sisplan_web\atualizador_loja_web.exe"""
echo WScript.Sleep 10000
echo WshShell.SendKeys "%Caminho%"
echo WshShell.SendKeys "{TAB}"
echo WshShell.SendKeys "{TAB}"
echo WScript.Sleep 2000
echo WshShell.SendKeys "%Apache24%/htdocs/sisplan_web"
) > temp.vbs

rem Executar o script VBS
start temp.vbs
rem Esperar 15 segundos e deletar o arquivo VBS temporario
timeout /t 15 >nul
del temp.vbs
goto ConferenciaAttWeb

:AtualizadorWeb
start "" "%Caminho%\atualizador_sisplan_web\atualizador_loja_web.exe"
timeout /t 5 >nul
goto ConferenciaAttWeb


:: ----------------- ATT WEB -----------------
:ConferenciaAttWeb
cls
set /p respostaattweb="O Atualizador do web rodou com sucesso? (S/N): "
if /i "%respostaattweb%"=="S" (
echo Show de Bola!
echo.
goto YahalloWeb
)
if /i "%respostaattweb%"=="N" (
echo Tente atualizar novamente ou realize o processo por fora do bat!
goto Procedimentos
)
echo Resposta invalida. Tente novamente.
goto ConferenciaAttWeb


:: ----------------- SERVICOS VOLTAR -----------------
:YahalloWeb
color 0E
rem Registrar a data e hora de fim da atualizacao
echo "Atualizacao finalizada em %date% %time%" > "%PastaBackupWeb%\Fim_%DataAtual%.txt"
echo "Versão web antiga %Webversion%"  >> "%PastaBackupWeb%\Fim_%DataAtual%.txt"

set /p putamerdaweb="Voltar os Servicos? (S/N): "
if /i "%putamerdaweb%"=="S" (
    goto VoltarServicosWeb
)
if /i "%putamerdaweb%"=="N" (
    echo Okay!
    goto AbrirWeb
)
echo Decida-se!
goto YahalloWeb

:VoltarServicosweb
cls
echo Iniciando os servicos...
call :RunAsAdmin8 "%Bat%Processos\ServVoltar.bat"
:RunAsAdmin8
powershell -Command "Start-Process cmd -ArgumentList '/c ""%~1""' -Verb runAs"
echo Espere que todos servicos foram processados.
pause


:: ----------------- ABRIR WEB -----------------
:AbrirWeb
set "Servico=ApacheLojaWeb"
for /f "tokens=2 delims=: " %%A in ('sc queryex "%Servico%" ^| findstr "PID"') do (
    set "PID=%%A"
)
if not defined PID (
    echo [ERRO] Servico %Servico% nao esta em execucao ou nao foi encontrado.
    echo.
    echo Teste Manualmente o Sistema WEB.
    pause
    goto ConferenciaWebLoja
)
for /f "tokens=2,3 delims=:" %%A in ('netstat -ano ^| findstr /i "LISTENING" ^| findstr " %PID%"') do (
    set "Endereco=%%A"
    set "Porta=%%B"
)
if not defined Porta (
    echo [ERRO] Nao foi possivel encontrar uma porta associada ao servico %Servico%.
    echo.
    echo Impossivel de abrir o sistema web automaticamente!
    timeout /t 5 >nul
    goto CompleteWeb
) else (
    echo [SUCESSO] A porta do servico e: !Porta!
    start http://localhost:%Porta%/sisplan_web/
    echo.
    echo Verifique se a atualizacao do Sistema Web ocorreu Corretamente!
    timeout /t 5 >nul
    goto CompleteWeb
)


:: ----------------- COMPLETEWEB -----------------
:CompleteWeb
cls
color 0B
set "Webini2=%Caminho%\ApiWeb.ini"
set "Webversion2="
for /f "tokens=*" %%a in ('type "%Webini2%"') do (
    if not defined Webversion2 (
        echo %%a | findstr /i "versao=" >nul
        if !errorlevel! == 0 (
            set "linha=%%a"
            for /f "tokens=2 delims==" %%b in ("!linha!") do (
                set "Webversion2=%%b"
            )
        )
    )
)
for /f %%A in ('powershell -Command "$env:user.ToUpper()"') do set "user=%%A"
for /f "tokens=1,2 delims=:" %%a in ("%time%") do set "HoraFimWeb=%%a:%%b"

echo BOM TRABALHO.
echo TECNICO RESPONSAVEL: %User% > "%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%\Complete.txt"
echo VERSAO WEB: %Webversion2% >> "%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%\Complete.txt"
echo INICIO ATT: %HoraInicioWeb% >> "%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%\Complete.txt"
echo FIM ATT: %HoraFimWeb% >> "%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%\Complete.txt"
echo. >> "%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%\Complete.txt"
echo - INICIADO OS SERVICOS QUE FORAM PARADOS; >> "%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%\Complete.txt"
echo - TESTADO O SISPLAN WEB E ERP; >> "%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%\Complete.txt"
echo - COMPACTADO O BACKUP; >> "%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%\Complete.txt"


:: ----------------- FIM ----------------
:Finaliza
cls
color 0B
echo BOM TRABALHO.
echo "Atualizacao finalizada em %date% %time%" > "%Caminho%\Agora\BackupATT_WEB\Backup_%DataAtual%\Fim_%DataAtual%.txt"
echo.
goto Procedimento


:: ******************************************************************** REPARA ********************************************************************
:Repara


:: ******************************************************************** ESTRUTURA ********************************************************************
:Estrutura

if /i "%Banco%"=="Firebird" (
echo Realizando Backup do banco Firebird.
goto BackupEstru
) else (
goto RodaEstru
)

:BackupEstru
set "iniestru=%Caminho%\Sisplan.ini"
set "BaseEstru="
for /f "tokens=*" %%a in ('type "%iniestru%"') do (
    if not defined BaseEstru (
        echo %%a | findstr /i "base=" >nul
        if !errorlevel! == 0 (
            set "linha=%%a"
            for /f "tokens=2 delims==" %%b in ("!linha!") do (
                set "BaseEstru=%%b"
            )
        )
    )
)

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
set PastaBackupEstru=%Caminho%\Agora\Backup_Estrutura\Backup_%DataAtual%

rem Verificar se a pasta de backup ja existe
if exist "%PastaBackupEstru%" (
    echo A pasta de backup ja existe, nao sera recriada.
    echo %PastaBackupEstru%
    echo.
) else (
    rem Criar uma pasta com a data no formato YYYY-MM-DD
    mkdir "%PastaBackupEstru%"
    echo Criando pasta de backup: %PastaBackupEstru%
    rem Realizar o backup das pastas
    echo.
    xcopy "%BaseEstru%" "%PastaBackupEstru%"
    pause
)

:RodaEstru
cls
(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.Run """%Caminho%\Sisplan_novo\Estrutura\Estrutura.exe"""
echo WScript.Sleep 4000
echo WshShell.SendKeys "%User%"
echo WshShell.SendKeys "{TAB}"
echo WScript.Sleep 1000
echo WshShell.SendKeys "%Senha%"
echo WshShell.SendKeys "{TAB}"
echo WshShell.SendKeys "{ENTER}"
) > temp.vbs

rem Executar o script VBS
start temp.vbs
rem Esperar 5 segundos e deletar o arquivo VBS temporario
timeout /t 5 >nul
del temp.vbs

cls
echo ####################
echo  RODANDO ESTRUTURA! 
echo ####################
echo.
pause
goto Procedimento


:: ******************************************************************** CONVERSAO ********************************************************************
:Conversao

