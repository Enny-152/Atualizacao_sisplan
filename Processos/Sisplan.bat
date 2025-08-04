@echo off
setlocal enabledelayedexpansion
color 0E

(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo WshShell.Run """%Caminho%\Sisplan.exe"""
echo WScript.Sleep 10000
echo WshShell.SendKeys "{TAB}"
echo WshShell.SendKeys "Kana$007"
echo WshShell.SendKeys "{ENTER}"
echo WScript.Sleep 2000
echo WshShell.SendKeys "{DELETE}"
echo WshShell.SendKeys "Sisplan.Julio.Pereira"
echo WScript.Sleep 2000
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
echo WshShell.SendKeys "{ENTER}"
) > temp.vbs