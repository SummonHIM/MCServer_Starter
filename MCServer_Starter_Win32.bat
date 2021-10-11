@echo off
set mainVersion=v1.0
title Minecraft 服务端启动器 %mainVersion%
:checkConfigExist
if not exist "startconfig.cfg" (
	set setXmsNum=0
	set setXmxNum=0
	goto firstConfig
) else (
    goto getConfig
)

:firstConfig
title Minecraft 服务端启动器 %mainVersion% - 启动配置
cls
echo --------------- 首次启动，请设置各项参数... ---------------
echo      [1] 服务端文件名：%setServerJarName%
echo      [2] 服务器内存设置：%setXmsNum%-%setXmxNum% MB
echo      [3] 服务器额外参数（可选）：%setExtraJavaArgs%
echo      [4] 自定义 Java 路径（可选）：%set3rdJavaPath%
echo      [5] 保存...
echo,
echo      [0] 下载服务端文件
echo,
choice /c 123450
set firstConfigChoice=%errorlevel%
if %firstConfigChoice%==1 (
	echo,
	echo 键入本文件夹内服务端文件名，示例如下：
	echo 选中后，单击右键复制，单击右键粘贴。
	echo,
    dir /a-d /b | findstr .jar
	echo,
	set /p setServerJarName=请输入字符串：
	goto firstConfig
)
if %firstConfigChoice%==2 (
	echo,
	echo 键入服务端最大内存运行大小（单位：MB）
	set /p setXmxNum=请输入整数数字：
	echo,
	echo 键入服务端最小内存运行大小（单位：MB，可选）
	set /p setXmsNum=请输入整数数字：
	goto firstConfig
)
if %firstConfigChoice%==3 (
	echo,
	echo 键入服务端额外 Java 启动参数，若不需要则留空即可。
	set /p setExtraJavaArgs=请输入字符串：
	
	goto firstConfig
)
if %firstConfigChoice%==4 (
	echo,
	echo 键入自定义 Java 的路径（直至java.exe），若使用计算机默认则留空即可。
	set /p set3rdJavaPath=请输入字符串：
	goto firstConfig
)
if %firstConfigChoice%==5 (
	goto configOK
)
if %firstConfigChoice%==6 (
	goto downloadMenu
)
:configOK
echo,
set configError=0
if "%setServerJarName%"=="" (
	echo 错误：未设置服务端文件名。
	set configError=1
)
if "%setXmxNum%"=="0" (
	echo 错误：未设置最大内存运行大小。
	set configError=1
)
if "%setXmxNum%" LSS "%setXmsNum%" (
	echo 错误：最大内存大小不得小于最小内存大小。
	set configError=1
)
if %configError%==1 (
	echo 按任意键返回...
	pause >nul
	goto firstConfig
)
choice /m 确定都设置完毕了吗？
set configOKChoice=%errorlevel%
if %configOKChoice%==1 (
	goto saveConfig
)
if %configOKChoice%==2 (
	goto firstConfig
)
:saveConfig
if "%setXmsNum%"=="0" ( 
	set setXmsNum="0"
)
if "%setExtraJavaArgs%"=="" ( 
	set setExtraJavaArgs=,,,
)
if "%set3rdJavaPath%"=="" ( 
	set set3rdJavaPath=java
)
title Minecraft 服务端启动器 %mainVersion% - 正在保存配置...
echo --------------- 正在保存配置... ---------------
echo %setServerJarName%>"startconfig.cfg"
echo %setXmxNum%>>"startconfig.cfg"
echo %setXmsNum%>>"startconfig.cfg"
echo %setExtraJavaArgs%>>"startconfig.cfg"
echo %set3rdJavaPath%>>"startconfig.cfg"
echo 完成...
echo,

:getConfig
title Minecraft 服务端启动器 %mainVersion% - 正在读取已保存的配置...
echo --------------- 正在读取已保存的配置... ---------------
for /f %%a in (startconfig.cfg) do (
set setServerJarName=%%~a
goto getConfigList1
)
:getConfigList1
echo 设定的服务端文件名为：%setServerJarName%。
for /f "skip=1 delims=" %%b in (startconfig.cfg) do (
set setXmxNum=%%~b
goto getConfigList2
)
:getConfigList2
echo 设定的最大内存运行大小为：%setXmxNum%MB。
for /f "skip=2 delims=" %%b in (startconfig.cfg) do (
set setXmsNum=%%~b
goto getConfigList3
)
:getConfigList3
echo 设定的最小内存运行大小为：%setXmsNum%MB。
for /f "skip=3 delims=" %%c in (startconfig.cfg) do (
set setExtraJavaArgs=%%~c
goto getConfigList4
)
:getConfigList4
if "%setExtraJavaArgs%"==",,," ( 
	echo 未设定的额外 Java 启动参数。 
	set setExtraJavaArgs=
) else ( echo 设定的额外 Java 启动参数为：%setExtraJavaArgs%。 )
for /f "skip=4 delims=" %%c in (startconfig.cfg) do (
set set3rdJavaPath=%%~c
goto getConfigList5
)
:getConfigList5
if "%set3rdJavaPath%"=="java" ( 
	echo 未设定自定义 Java。 
) else ( echo 设定的自定义 Java 路径为：%set3rdJavaPath%。 )


echo,
title Minecraft 服务端启动器 %mainVersion% - 正在获取本机 IP 与端口...
echo --------------- 正在获取本机 IP 与端口... ---------------
for /f "tokens=2 delims=:" %%i in ('ipconfig^|find /i "IPv4"') do (
	set nowIP=%%i
	goto IPDone
)
:IPDone
if not "%nowIP%"=="" (
	echo  -- 成功，IP 为：%nowIP:~1%
) else (
	echo  -- 获取 IP 失败
)
for /f "tokens=2 delims==" %%p in ('findstr /n server-port server.properties') do (
	set Port=%%p
	goto portDone
)
:portDone
if not "%Port%"=="" (
	echo  -- 成功，端口为：%Port%
) else (
	echo  -- 获取端口失败
)

echo,
title Minecraft 服务端启动器 %mainVersion% - 正在验证文件...
echo --------------- 正在验证文件... ---------------
if not exist %setServerJarName% ( 
	echo,
	title 错误：缺少文件！
	echo 缺少 %setServerJarName%！
	echo 检查服务端文件是否完整。
	echo 若初始配置时参数输入有误，请删除文件 startconfig.cfg 或直接打开修改。
	echo 按任意键退出...
	pause >nul
	exit
) else (
	echo 服务端文件完整。
)
if "%set3rdJavaPath%"=="java" (
	java -version
	if errorlevel 9009 (
		echo,
		echo 未在您的计算机中找到 Java！
		echo 请前去 Java 官方网站（java.com）下载最新版本的 Java。
		echo,
		echo 按任意键退出并打开 Java 官网...
		pause >nul
        start http://java.com
		exit
	) else (
	echo Java 文件完整。
	)
) else (
	if not exist "%set3rdJavaPath%" (
		echo,
		echo 未在您自定义的路径 "%set3rdJavaPath%" 中找到 Java！
		echo 若初始配置时参数输入有误，请删除文件 startconfig.cfg 或直接打开修改。
		echo,
		echo 按任意键退出并打开 Java 官网...
		pause >nul
        start http://java.com
		exit
	) else (
	echo Java 文件完整。
	)
)
echo  -- 完整
echo,

:startServer
echo --------------- Minecraft %setServerJarName% 服务端启动中... ---------------
title Minecraft 服务端启动中...   IP:%nowIP:~1%:%Port%，内存:%setXmsNum%-%setXmxNum%MB，键入stop或按Ctrl+C键可停止服务端
echo "%set3rdJavaPath%" -Xms%setXmsNum%M -Xmx%setXmxNum%M %setExtraJavaArgs% -jar %setServerJarName% nogui
"%set3rdJavaPath%" -Xms%setXmsNum%M -Xmx%setXmxNum%M %setExtraJavaArgs% -jar %setServerJarName% nogui
echo,
title Minecraft 服务端已关闭...
echo --------------- Minecraft %setServerJarName% 服务端已关闭... ---------------
echo Tips: 若要重新配置本启动器，直接删除 startconfig.cfg 并重启脚本即可。
echo,

if exist eula.txt (
    goto checkEULA
) else (
    goto debugMode
)
:checkEULA
for /f "skip=2 tokens=2 delims==" %%i in ('find /i "eula=" eula.txt') do (
	    set eulaStatus=%%i
)
if %eulaStatus%==false (
    echo 您需要同意最终用户许可协议（EULA）才能运行服务器。
	echo 请前去 eula.txt 文件并将 “eula=false” 更改为 “eula=true” 以表明您同意 Mojang 的 EULA。
	echo 更多详情请参阅：https://account.mojang.com/documents/minecraft_eula
	echo,
	start https://account.mojang.com/documents/minecraft_eula
)

:debugMode
if exist "Debug.ON" (
	echo 按任意键删除数据...
	pause >nul
	for /f "tokens=2 delims=:" %%i in ('find /i "file:" Debug.ON') do (
		echo 正在删除文件 %%i...
    	del /q %%i
	)
	for /f "tokens=2 delims=:" %%i in ('find /i "folder:" Debug.ON') do (
		echo 正在删除文件夹 %%i...
	    rmdir /s /q %%i
	)
	echo,
)
echo 按任意键退出...
pause >nul
exit


:downloadMenu
title Minecraft 服务端启动器 %mainVersion% - 下载服务端
cls
echo --------------- 请选择欲下载的服务端类型... ---------------
echo      [1] 原版 (BMCLAPI)
echo      Bukkit
echo      --- [2] Spigot
echo      --- [3] PaperMC
echo      --- [4] TacoSpigot
echo      --- [5] Purpur
echo      --- [6] Mohist
echo      Sponge
echo      --- [7] SpongeVanilla
echo      --- [8] SpongeForge
echo,
echo      [0] 返回启动配置
choice /c 123456780
set downloadMenuChoice=%errorlevel%
if %downloadMenuChoice%==1 (
	goto vainllaConfigs
)
if %downloadMenuChoice%==2 (
	goto spigotConfigs
)
if %downloadMenuChoice%==3 (
	goto paperConfigs
)
if %downloadMenuChoice%==4 (
	goto tacoSpigotConfigs
)
if %downloadMenuChoice%==5 (
	goto purpurConfigs
)
if %downloadMenuChoice%==6 (
	goto mohistConfigs
)
if %downloadMenuChoice%==7 (
	goto spongeVanillaConfigs
)
if %downloadMenuChoice%==8 (
	goto spongeForgeConfigs
)
if %downloadMenuChoice%==9 (
	goto firstConfig
)

:vainllaConfigs
echo,
set /p downloadVersion=请输入欲下载的 Java 服务端版本号（如1.7.10）：
set downloadAPIUrls=https://bmclapi2.bangbang93.com/version/%downloadVersion%/server
set downloadFileName=minecraft_server
goto apiDownload

:spigotConfigs
echo,
echo 请输入欲下载的 Spigot 服务端构建编号（如130）
set /p downloadVersion=留空则使用最新成功构建版本：
if "%downloadVersion%"=="" ( 
	set downloadVersion=lastSuccessfulBuild
)
set downloadAPIUrls=https://hub.spigotmc.org/jenkins/job/BuildTools/%downloadVersion%/artifact/target/BuildTools.jar
set downloadFileName=spigot_server
goto apiDownload

:paperConfigs
echo,
set /p downloadVainllaVersion=请输入欲下载的 Java 服务端版本号（如1.12.2）：
echo 请输入欲下载的 PaperMC 服务端构建编号（如130）
set /p downloadVersion=留空则前去浏览器查看支持的构建编号：
if "%downloadVersion%"=="" ( 
	start https://papermc.io/api/v2/projects/paper/versions/%downloadVainllaVersion%
	goto downloadMenu
)
set downloadAPIUrls=https://papermc.io/api/v2/projects/paper/versions/%downloadVainllaVersion%/builds/%downloadVersion%/downloads/paper-%downloadVainllaVersion%-%downloadVersion%.jar
set downloadFileName=paper-%downloadVainllaVersion%
goto apiDownload

:tacoSpigotConfigs
echo,
set /p downloadVersion=请输入欲下载的 TacoSpigot 服务端版本号（如v1.9.4-R0.1）：
set downloadAPIUrls=https://github.com/TacoSpigot/TacoSpigot/releases/download/%downloadVersion%/TacoSpigot.jar
set downloadFileName=TacoSpigot
goto apiDownload

:purpurConfigs
echo,
set /p downloadVainllaVersion=请输入欲下载的 Java 服务端版本号（如1.14.1）：
echo 请输入欲下载的 Purpur 服务端构建编号（如1393）
set /p downloadVersion=留空则下载最新的构建编号：
if "%downloadVersion%"=="" ( 
	set downloadVersion=latest
)
set downloadAPIUrls=https://api.pl3x.net/v2/purpur/%downloadVainllaVersion%/%downloadVersion%/download
set downloadFileName=purpur-%downloadVainllaVersion%
goto apiDownload

:mohistConfigs
echo,
set /p downloadVainllaVersion=请输入欲下载的 Java 服务端版本号（如1.12.2）：
echo 请输入欲下载的 Mohist 服务端构建编号（如1393）
set /p downloadVersion=留空则下载最新的构建编号：
if "%downloadVersion%"=="" ( 
	set downloadVersion=latest
)
set downloadAPIUrls=https://mohistmc.com/api/%downloadVainllaVersion%/%downloadVersion%/download
set downloadFileName=mohist-%downloadVainllaVersion%
goto apiDownload

:spongeVanillaConfigs
echo,
set /p downloadVersion=请输入欲下载的 Sponge Vanilla 服务端版本号（如1.12.2-7.3.0）：
set downloadAPIUrls=https://repo.spongepowered.org/maven/org/spongepowered/spongevanilla/%downloadVersion%/spongevanilla-%downloadVersion%.jar
set downloadFileName=spongevanilla
goto apiDownload

:spongeForgeConfigs
echo,
set /p downloadVersion=请输入欲下载的 Sponge Forge 服务端版本号（如1.12.2-2838-7.3.0）：
set downloadAPIUrls=https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/%downloadVersion%/spongeforge-%downloadVersion%.jar
set downloadFileName=spongeforge
goto apiDownload

:apiDownload
echo,
echo 正在下载中，请稍后...
echo 地址：%downloadAPIUrls%，保存至：%downloadFileName%-%downloadVersion%.jar
powershell Invoke-WebRequest "%downloadAPIUrls%" -OutFile "%downloadFileName%-%downloadVersion%.jar"
echo,
for /f %%a in (%downloadFileName%-%downloadVersion%.jar) do (
	set downloadStatus=%%a
	goto statusDone
)
:statusDone
if not exist "%downloadFileName%-%downloadVersion%.jar" (
	echo 下载失败，版本不存在。
	echo 按任意键返回...
	pause >nul
	goto downloadMenu
)
if "%downloadStatus%"=="Not" (
	echo 下载失败，版本不存在。
	del /q %downloadFileName%-%downloadVersion%.jar
	echo 按任意键返回...
	pause >nul
	goto downloadMenu
)
if "%downloadStatus%"=="<!DOCTYPE" (
	echo 下载失败，版本不存在。
	del /q %downloadFileName%-%downloadVersion%.jar
	echo 按任意键返回...
	pause >nul
	goto downloadMenu
)
if "%downloadStatus%"=="<html>" (
	echo 下载失败，版本不存在。
	del /q %downloadFileName%-%downloadVersion%.jar
	echo 按任意键返回...
	pause >nul
	goto downloadMenu
) else (
	echo 下载成功。
	echo 按任意键返回...
	pause >nul
	goto downloadMenu
)