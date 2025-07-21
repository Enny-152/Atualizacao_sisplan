@echo off
setlocal enabledelayedexpansion
color 0E

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Este script precisa ser executado como Administrador.
    echo Tentando reiniciar com privilegios de Administrador...
    timeout /t 3 /nobreak >nul
    rem Reinicia o script como Administrador
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dp0%~nx0' -Verb runAs"
    exit /b
)

echo [OK] O script esta rodando como Administrador.
