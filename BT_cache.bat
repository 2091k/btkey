@echo off
title                 κ����@����BT���                         
color A
echo==============================================================
echo          ����׼�����BarTender�����ļ�...
echo==============================================================

echo.
echo.
echo.

set "root1=C:\ProgramData\Seagull"
set "root2=C:\Users\%USERNAME%\Documents\BarTender"


echo �������� %root1% ...

del /f /s /q "%root1%\*.*"

for /d /r "%root1%" %%d in (*) do (
    if exist "%%d" (
        echo ɾ�����ļ���: %%d
        rmdir /s /q "%%d"
    )
)


echo.
echo �������� %root2% ...
del /f /s /q "%root2%\*.*"
for /d /r "%root2%" %%d in (*) do (
    if exist "%%d" (
        echo ɾ�����ļ���: %%d
        rmdir /s /q "%%d"
    )
)
echo.
echo.
echo.
echo �������
pause

