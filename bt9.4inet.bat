@echo off
chcp 65001 >nul
title BT9.4专业网络工具
color 0A

:: 管理员权限检查（必须）
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 请右键点击此脚本，选择【以管理员身份运行】！
    pause >nul
    exit /b 1
)

echo ==============================================
echo          Bartender9.4工具
echo ==============================================
echo.


echo [1/6] 
sc config MpsSvc start= auto >nul 2>&1  :: 设置服务为自动启动（手动开启的前提）
net stop MpsSvc >nul 2>&1              :: 先停止服务（避免占用）
net start MpsSvc >nul 2>&1             :: 重新启动服务
timeout /t 3 /nobreak >nul             :: 等待3秒让服务加载完成

:: 
sc query MpsSvc | findstr /i "RUNNING" >nul
if %errorlevel% neq 0 (
    echo 服务启动失败！请先手动开启：
    echo    1. 按下Win+R，输入services.msc
    echo    2. 找到Windows Defender Firewall（MpsSvc）
    echo    3. 右键选择【启动】，启动类型设为【自动】
    pause >nul
    exit /b 1
)
echo 核心服务已启动
echo.

）
echo [2/6] 正在模拟手动开启（所有网络环境）...

reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v EnableFirewall /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v EnableFirewall /t REG_DWORD /d 1 /f >nul 2>&1
）
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v EnableFirewall /t REG_DWORD /d 1 /f >nul 2>&1

netsh advfirewall set allprofiles state on >nul 2>&1
echo 已模拟手动开启（域/专用/公用网络均启用）
echo.


echo [3/6] 验证状态...
netsh advfirewall show allprofiles | findstr /i "启用" >nul
if %errorlevel% equ 0 (
    echo 验证通过：已成功开启
) else (
    echo 配置已修改，建议手动确认：
    echo    路径：控制面板 → 系统和安全 → Windows Defender
    start control firewall.cpl  :: 直接打开图形界面，方便你手动确认/开启
    pause >nul
)
echo.

:: 4. 获取用户输入的安装路径
set "bartenderPath="
:inputPath
set /p "bartenderPath=请输入Bartender安装路径（例：C:\Program Files (x86)\Seagull\Bartender 9.4）："
if "%bartenderPath%"=="" (
    echo 路径不能为空，请重新输入！
    goto inputPath
)

:: 5. 验证两个EXE文件存在
set "exePath1=%bartenderPath%\BarTend.exe"
set "exePath2=%bartenderPath%\ActivationWizard.exe"
echo.
echo [4/6] 验证文件路径...
if not exist "%exePath1%" (
    echo 未找到BarTend.exe，请检查路径！
    goto inputPath
)
if not exist "%exePath2%" (
    echo 未找到ActivationWizard.exe，请检查路径！
    goto inputPath
)
echo 两个文件路径验证成功
echo.

:: 6. 添加禁止联网规则（01=BarTend.exe，02=ActivationWizard.exe）
echo [5/6] 添加BarTend.exe禁止联网规则（01）...
netsh advfirewall firewall delete rule name="01" >nul 2>&1
netsh advfirewall firewall add rule name="01" dir=out action=block program="%exePath1%" enable=yes profile=any >nul 2>&1

echo [6/6] 添加ActivationWizard.exe禁止联网规则（02）...
netsh advfirewall firewall delete rule name="02" >nul 2>&1
netsh advfirewall firewall add rule name="02" dir=out action=block program="%exePath2%" enable=yes profile=any >nul 2>&1

echo 两个程序的禁止联网规则已添加完成
echo.

:: 最终提示
echo ==============================================
echo 操作全部完成！
echo 1. 已模拟手动开启（核心服务+注册表+配置均生效）
echo 2. BarTend.exe（规则01）已禁止联网
echo 3. ActivationWizard.exe（规则02）已禁止联网
echo.
echo 手动验证步骤：
echo 1. 打开控制面板 → 系统和安全 → Windows Defender
echo 2. 确认显示「Windows Defender已启用」
echo 3. 点击【高级设置】→ 出站规则，可看到01、02两条规则
echo ==============================================

:: 直接打开图形界面，方便你确认
start control firewall.cpl

echo.
pause >nul