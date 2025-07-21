@echo off
setlocal enabledelayedexpansion
color 0E

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
    echo A pasta de backup %PastaBackup% ja existe. Nao sera recriada.
) else (
    rem Criar uma pasta com a data no formato YYYY-MM-DD
    mkdir "%PastaBackup%"
    echo Criando pasta de backup: %PastaBackup%

    rem Realizar o backup das pastas
    xcopy "%Caminho%\Relatorio" "%PastaBackup%\Relatorio" /E /I /Y >nul
    if exist "%PastaBackup%\Relatorio" echo Backup pasta Relatorio feito com sucesso!
    xcopy "%Caminho%\Layout" "%PastaBackup%\Layout" /E /I /Y >nul
    if exist "%PastaBackup%\Layout" echo Backup pasta Layout feito com sucesso!
    xcopy "%Caminho%\Base" "%PastaBackup%\Base" /E /I /Y >nul
    if exist "%PastaBackup%\Base" echo Backup pasta Base feito com sucesso!
    echo Backup das pastas concluido.

    rem Registrar a data e hora de inicio do backup
    echo "Atualizacao iniciada em %date% %time%" > "%PastaBackup%\Inicio_%DataAtual%.txt"
)