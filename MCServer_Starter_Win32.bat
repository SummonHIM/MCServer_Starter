@echo off
set mainVersion=v1.0
title Minecraft ����������� %mainVersion%
:checkConfigExist
if not exist "startconfig.cfg" (
	set setXmsNum=0
	set setXmxNum=0
	goto firstConfig
) else (
    goto getConfig
)

:firstConfig
title Minecraft ����������� %mainVersion% - ��������
cls
echo --------------- �״������������ø������... ---------------
echo      [1] ������ļ�����%setServerJarName%
echo      [2] �������ڴ����ã�%setXmsNum%-%setXmxNum% MB
echo      [3] �����������������ѡ����%setExtraJavaArgs%
echo      [4] �Զ��� Java ·������ѡ����%set3rdJavaPath%
echo      [5] ����...
echo,
echo      [0] ���ط�����ļ�
echo,
choice /c 123450
set firstConfigChoice=%errorlevel%
if %firstConfigChoice%==1 (
	echo,
	echo ���뱾�ļ����ڷ�����ļ�����ʾ�����£�
	echo ѡ�к󣬵����Ҽ����ƣ������Ҽ�ճ����
	echo,
    dir /a-d /b | findstr .jar
	echo,
	set /p setServerJarName=�������ַ�����
	goto firstConfig
)
if %firstConfigChoice%==2 (
	echo,
	echo ������������ڴ����д�С����λ��MB��
	set /p setXmxNum=�������������֣�
	echo,
	echo ����������С�ڴ����д�С����λ��MB����ѡ��
	set /p setXmsNum=�������������֣�
	goto firstConfig
)
if %firstConfigChoice%==3 (
	echo,
	echo �������˶��� Java ����������������Ҫ�����ռ��ɡ�
	set /p setExtraJavaArgs=�������ַ�����
	
	goto firstConfig
)
if %firstConfigChoice%==4 (
	echo,
	echo �����Զ��� Java ��·����ֱ��java.exe������ʹ�ü����Ĭ�������ռ��ɡ�
	set /p set3rdJavaPath=�������ַ�����
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
	echo ����δ���÷�����ļ�����
	set configError=1
)
if "%setXmxNum%"=="0" (
	echo ����δ��������ڴ����д�С��
	set configError=1
)
if "%setXmxNum%" LSS "%setXmsNum%" (
	echo ��������ڴ��С����С����С�ڴ��С��
	set configError=1
)
if %configError%==1 (
	echo �����������...
	pause >nul
	goto firstConfig
)
choice /m ȷ���������������
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
title Minecraft ����������� %mainVersion% - ���ڱ�������...
echo --------------- ���ڱ�������... ---------------
echo %setServerJarName%>"startconfig.cfg"
echo %setXmxNum%>>"startconfig.cfg"
echo %setXmsNum%>>"startconfig.cfg"
echo %setExtraJavaArgs%>>"startconfig.cfg"
echo %set3rdJavaPath%>>"startconfig.cfg"
echo ���...
echo,

:getConfig
title Minecraft ����������� %mainVersion% - ���ڶ�ȡ�ѱ��������...
echo --------------- ���ڶ�ȡ�ѱ��������... ---------------
for /f %%a in (startconfig.cfg) do (
set setServerJarName=%%~a
goto getConfigList1
)
:getConfigList1
echo �趨�ķ�����ļ���Ϊ��%setServerJarName%��
for /f "skip=1 delims=" %%b in (startconfig.cfg) do (
set setXmxNum=%%~b
goto getConfigList2
)
:getConfigList2
echo �趨������ڴ����д�СΪ��%setXmxNum%MB��
for /f "skip=2 delims=" %%b in (startconfig.cfg) do (
set setXmsNum=%%~b
goto getConfigList3
)
:getConfigList3
echo �趨����С�ڴ����д�СΪ��%setXmsNum%MB��
for /f "skip=3 delims=" %%c in (startconfig.cfg) do (
set setExtraJavaArgs=%%~c
goto getConfigList4
)
:getConfigList4
if "%setExtraJavaArgs%"==",,," ( 
	echo δ�趨�Ķ��� Java ���������� 
	set setExtraJavaArgs=
) else ( echo �趨�Ķ��� Java ��������Ϊ��%setExtraJavaArgs%�� )
for /f "skip=4 delims=" %%c in (startconfig.cfg) do (
set set3rdJavaPath=%%~c
goto getConfigList5
)
:getConfigList5
if "%set3rdJavaPath%"=="java" ( 
	echo δ�趨�Զ��� Java�� 
) else ( echo �趨���Զ��� Java ·��Ϊ��%set3rdJavaPath%�� )


echo,
title Minecraft ����������� %mainVersion% - ���ڻ�ȡ���� IP ��˿�...
echo --------------- ���ڻ�ȡ���� IP ��˿�... ---------------
for /f "tokens=2 delims=:" %%i in ('ipconfig^|find /i "IPv4"') do (
	set nowIP=%%i
	goto IPDone
)
:IPDone
if not "%nowIP%"=="" (
	echo  -- �ɹ���IP Ϊ��%nowIP:~1%
) else (
	echo  -- ��ȡ IP ʧ��
)
for /f "tokens=2 delims==" %%p in ('findstr /n server-port server.properties') do (
	set Port=%%p
	goto portDone
)
:portDone
if not "%Port%"=="" (
	echo  -- �ɹ����˿�Ϊ��%Port%
) else (
	echo  -- ��ȡ�˿�ʧ��
)

echo,
title Minecraft ����������� %mainVersion% - ������֤�ļ�...
echo --------------- ������֤�ļ�... ---------------
if not exist %setServerJarName% ( 
	echo,
	title ����ȱ���ļ���
	echo ȱ�� %setServerJarName%��
	echo ��������ļ��Ƿ�������
	echo ����ʼ����ʱ��������������ɾ���ļ� startconfig.cfg ��ֱ�Ӵ��޸ġ�
	echo ��������˳�...
	pause >nul
	exit
) else (
	echo ������ļ�������
)
if "%set3rdJavaPath%"=="java" (
	java -version
	if errorlevel 9009 (
		echo,
		echo δ�����ļ�������ҵ� Java��
		echo ��ǰȥ Java �ٷ���վ��java.com���������°汾�� Java��
		echo,
		echo ��������˳����� Java ����...
		pause >nul
        start http://java.com
		exit
	) else (
	echo Java �ļ�������
	)
) else (
	if not exist "%set3rdJavaPath%" (
		echo,
		echo δ�����Զ����·�� "%set3rdJavaPath%" ���ҵ� Java��
		echo ����ʼ����ʱ��������������ɾ���ļ� startconfig.cfg ��ֱ�Ӵ��޸ġ�
		echo,
		echo ��������˳����� Java ����...
		pause >nul
        start http://java.com
		exit
	) else (
	echo Java �ļ�������
	)
)
echo  -- ����
echo,

:startServer
echo --------------- Minecraft %setServerJarName% �����������... ---------------
title Minecraft �����������...   IP:%nowIP:~1%:%Port%���ڴ�:%setXmsNum%-%setXmxNum%MB������stop��Ctrl+C����ֹͣ�����
echo "%set3rdJavaPath%" -Xms%setXmsNum%M -Xmx%setXmxNum%M %setExtraJavaArgs% -jar %setServerJarName% nogui
"%set3rdJavaPath%" -Xms%setXmsNum%M -Xmx%setXmxNum%M %setExtraJavaArgs% -jar %setServerJarName% nogui
echo,
title Minecraft ������ѹر�...
echo --------------- Minecraft %setServerJarName% ������ѹر�... ---------------
echo Tips: ��Ҫ�������ñ���������ֱ��ɾ�� startconfig.cfg �������ű����ɡ�
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
    echo ����Ҫͬ�������û����Э�飨EULA���������з�������
	echo ��ǰȥ eula.txt �ļ����� ��eula=false�� ����Ϊ ��eula=true�� �Ա�����ͬ�� Mojang �� EULA��
	echo ������������ģ�https://account.mojang.com/documents/minecraft_eula
	echo,
	start https://account.mojang.com/documents/minecraft_eula
)

:debugMode
if exist "Debug.ON" (
	echo �������ɾ������...
	pause >nul
	for /f "tokens=2 delims=:" %%i in ('find /i "file:" Debug.ON') do (
		echo ����ɾ���ļ� %%i...
    	del /q %%i
	)
	for /f "tokens=2 delims=:" %%i in ('find /i "folder:" Debug.ON') do (
		echo ����ɾ���ļ��� %%i...
	    rmdir /s /q %%i
	)
	echo,
)
echo ��������˳�...
pause >nul
exit


:downloadMenu
title Minecraft ����������� %mainVersion% - ���ط����
cls
echo --------------- ��ѡ�������صķ��������... ---------------
echo      [1] ԭ�� (BMCLAPI)
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
echo      [0] ������������
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
set /p downloadVersion=�����������ص� Java ����˰汾�ţ���1.7.10����
set downloadAPIUrls=https://bmclapi2.bangbang93.com/version/%downloadVersion%/server
set downloadFileName=minecraft_server
goto apiDownload

:spigotConfigs
echo,
echo �����������ص� Spigot ����˹�����ţ���130��
set /p downloadVersion=������ʹ�����³ɹ������汾��
if "%downloadVersion%"=="" ( 
	set downloadVersion=lastSuccessfulBuild
)
set downloadAPIUrls=https://hub.spigotmc.org/jenkins/job/BuildTools/%downloadVersion%/artifact/target/BuildTools.jar
set downloadFileName=spigot_server
goto apiDownload

:paperConfigs
echo,
set /p downloadVainllaVersion=�����������ص� Java ����˰汾�ţ���1.12.2����
echo �����������ص� PaperMC ����˹�����ţ���130��
set /p downloadVersion=������ǰȥ������鿴֧�ֵĹ�����ţ�
if "%downloadVersion%"=="" ( 
	start https://papermc.io/api/v2/projects/paper/versions/%downloadVainllaVersion%
	goto downloadMenu
)
set downloadAPIUrls=https://papermc.io/api/v2/projects/paper/versions/%downloadVainllaVersion%/builds/%downloadVersion%/downloads/paper-%downloadVainllaVersion%-%downloadVersion%.jar
set downloadFileName=paper-%downloadVainllaVersion%
goto apiDownload

:tacoSpigotConfigs
echo,
set /p downloadVersion=�����������ص� TacoSpigot ����˰汾�ţ���v1.9.4-R0.1����
set downloadAPIUrls=https://github.com/TacoSpigot/TacoSpigot/releases/download/%downloadVersion%/TacoSpigot.jar
set downloadFileName=TacoSpigot
goto apiDownload

:purpurConfigs
echo,
set /p downloadVainllaVersion=�����������ص� Java ����˰汾�ţ���1.14.1����
echo �����������ص� Purpur ����˹�����ţ���1393��
set /p downloadVersion=�������������µĹ�����ţ�
if "%downloadVersion%"=="" ( 
	set downloadVersion=latest
)
set downloadAPIUrls=https://api.pl3x.net/v2/purpur/%downloadVainllaVersion%/%downloadVersion%/download
set downloadFileName=purpur-%downloadVainllaVersion%
goto apiDownload

:mohistConfigs
echo,
set /p downloadVainllaVersion=�����������ص� Java ����˰汾�ţ���1.12.2����
echo �����������ص� Mohist ����˹�����ţ���1393��
set /p downloadVersion=�������������µĹ�����ţ�
if "%downloadVersion%"=="" ( 
	set downloadVersion=latest
)
set downloadAPIUrls=https://mohistmc.com/api/%downloadVainllaVersion%/%downloadVersion%/download
set downloadFileName=mohist-%downloadVainllaVersion%
goto apiDownload

:spongeVanillaConfigs
echo,
set /p downloadVersion=�����������ص� Sponge Vanilla ����˰汾�ţ���1.12.2-7.3.0����
set downloadAPIUrls=https://repo.spongepowered.org/maven/org/spongepowered/spongevanilla/%downloadVersion%/spongevanilla-%downloadVersion%.jar
set downloadFileName=spongevanilla
goto apiDownload

:spongeForgeConfigs
echo,
set /p downloadVersion=�����������ص� Sponge Forge ����˰汾�ţ���1.12.2-2838-7.3.0����
set downloadAPIUrls=https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/%downloadVersion%/spongeforge-%downloadVersion%.jar
set downloadFileName=spongeforge
goto apiDownload

:apiDownload
echo,
echo ���������У����Ժ�...
echo ��ַ��%downloadAPIUrls%����������%downloadFileName%-%downloadVersion%.jar
powershell Invoke-WebRequest "%downloadAPIUrls%" -OutFile "%downloadFileName%-%downloadVersion%.jar"
echo,
for /f %%a in (%downloadFileName%-%downloadVersion%.jar) do (
	set downloadStatus=%%a
	goto statusDone
)
:statusDone
if not exist "%downloadFileName%-%downloadVersion%.jar" (
	echo ����ʧ�ܣ��汾�����ڡ�
	echo �����������...
	pause >nul
	goto downloadMenu
)
if "%downloadStatus%"=="Not" (
	echo ����ʧ�ܣ��汾�����ڡ�
	del /q %downloadFileName%-%downloadVersion%.jar
	echo �����������...
	pause >nul
	goto downloadMenu
)
if "%downloadStatus%"=="<!DOCTYPE" (
	echo ����ʧ�ܣ��汾�����ڡ�
	del /q %downloadFileName%-%downloadVersion%.jar
	echo �����������...
	pause >nul
	goto downloadMenu
)
if "%downloadStatus%"=="<html>" (
	echo ����ʧ�ܣ��汾�����ڡ�
	del /q %downloadFileName%-%downloadVersion%.jar
	echo �����������...
	pause >nul
	goto downloadMenu
) else (
	echo ���سɹ���
	echo �����������...
	pause >nul
	goto downloadMenu
)