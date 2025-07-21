@echo off
setlocal enabledelayedexpansion
color 0E

@echo off
:: Habilita o uso de sequências ANSI no terminal do Windows
if not "%ANSICON%"=="" goto :start
for /f "tokens=2 delims==" %%a in ('"chcp"') do set "_CHCP=%%a"
chcp 65001 > nul

:start
:: Define cores usando códigos ANSI
:: \033[ = Inicia a sequência ANSI
:: 32m = Verde, 33m = Amarelo, 31m = Vermelho
set "ESC="
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"

echo %ESC%[32mTexto em verde%ESC%[0m
echo %ESC%[33mTexto em amarelo%ESC%[0m
echo %ESC%[31mTexto em vermelho%ESC%[0m

:: Restaura o código de página original
chcp %_CHCP% > nul
pause
