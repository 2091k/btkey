@echo off
title                 魏无羡@艾伦BT软件                         
color A
echo==============================================================
echo          正在准备清空BarTender缓存文件...
echo==============================================================

echo.
echo.
echo.

set "root1=C:\ProgramData\Seagull"
set "root2=C:\Users\%USERNAME%\Documents\BarTender"


echo 正在清理 %root1% ...

del /f /s /q "%root1%\*.*"

for /d /r "%root1%" %%d in (*) do (
    if exist "%%d" (
        echo 删除子文件夹: %%d
        rmdir /s /q "%%d"
    )
)


echo.
echo 正在清理 %root2% ...
del /f /s /q "%root2%\*.*"
for /d /r "%root2%" %%d in (*) do (
    if exist "%%d" (
        echo 删除子文件夹: %%d
        rmdir /s /q "%%d"
    )
)
echo.
echo.
echo.
echo 清理完成
pause

