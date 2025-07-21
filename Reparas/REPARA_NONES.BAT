@echo off
set PATH=%PATH%;"C:\Program Files\Firebird\Firebird_2_5\bin"

echo Recuperando banco de dados...
GFIX -user sysdba -password masterkey -mend %1

PAUSE

echo Backup do banco para backup.bkp

gbak -v -t -user sysdba -password masterkey %1 backup.bkp

PAUSE

echo Restaurando o Banco

gbak -rep -c -v -FIX_FSS_D WIN1252 -FIX_FSS_M WIN1252 -P 8192 -user sysdba -password masterkey backup.bkp %1

echo Terminado
√‹