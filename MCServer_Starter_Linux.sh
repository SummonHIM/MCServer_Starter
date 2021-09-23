#!/bin/bash
mainVersion=1.0

firstConfig() {
    clear
    echo --------------- 首次启动，请设置各项参数... ---------------
    PS3='请选择一项选项：'
    firstConfigChoice=("服务端文件名：$setServerJarName" "服务器内存设置：$setXmsNum-$setXmxNum MB" "服务器额外参数（可选）：$setExtraJavaArgs" "自定义 Java 路径（可选）：$set3rdJavaPath" "保存...")
    select firstConfigChoices in "${firstConfigChoice[@]}"; do
        case $firstConfigChoices in
        "服务端文件名：$setServerJarName")
            echo
            echo 键入本文件夹内服务端文件名，示例如下：
            echo 选中后，单击右键复制，单击右键粘贴。
            echo
            ls | grep .jar
            echo
            read -p "请输入字符串：" setServerJarName
            firstConfig
            break
            ;;
        "服务器内存设置：$setXmsNum-$setXmxNum MB")
            echo
            echo 键入服务端最大内存运行大小（单位：MB）
            read -p "请输入整数数字：" setXmxNum
            echo
            echo 键入服务端最小内存运行大小（单位：MB，可选）
            read -p "请输入整数数字：" setXmsNum
            if [ -z $setXmsNum ]; then
                setXmsNum=0
            fi
            firstConfig
            break
            ;;
        "服务器额外参数（可选）：$setExtraJavaArgs")
            echo
            echo 键入服务端额外 Java 启动参数，若不需要则留空即可。
            read -p "请输入字符串：" setExtraJavaArgs
            firstConfig
            break
            ;;
        "自定义 Java 路径（可选）：$set3rdJavaPath")
            echo
            echo 键入自定义 Java 的路径（直至java.exe），若使用计算机默认则留空即可。
            read -p "请输入字符串：" set3rdJavaPath
            firstConfig
            break
            ;;
        "保存...")
            if [ -z $setServerJarName ]; then
                echo 错误：未设置服务端文件名。
                configError=1
            fi
            if [ $setXmxNum == 0 ]; then
                echo 错误：未设置最大内存运行大小。
                configError=1
            fi
            if [ $setXmxNum -lt $setXmsNum ]; then
                echo 错误：最大内存大小不得小于最小内存大小。
                configError=1
            fi
            if [ $configError == 1 ]; then
                read -s -n1 -p "按任意键返回..."
                configError=0
                firstConfig
                break
            fi
            echo
            echo 确定都设置完毕了吗？
            PS3='请选择一项选项：'
            configOKChoice=("是" "否")
            select configOKChoices in "${configOKChoice[@]}"; do
                case $configOKChoices in
                "是")
                    echo
                    echo --------------- 正在保存配置... ---------------
                    if [ -z $setExtraJavaArgs ]; then
                        setExtraJavaArgs=,,,
                    fi
                    if [ -z $set3rdJavaPath ]; then
                        set3rdJavaPath=java
                    fi
                    echo $setServerJarName >"startconfig.cfg"
                    echo $setXmxNum >>"startconfig.cfg"
                    echo $setXmsNum >>"startconfig.cfg"
                    echo $setExtraJavaArgs >>"startconfig.cfg"
                    echo $set3rdJavaPath >>"startconfig.cfg"
                    echo 完成...
                    echo 
                    break
                    ;;
                "否")
                    firstConfig
                    break
                    ;;
                *) echo "选项 $REPLY 无效" ;;
                esac
            done
            break
            ;;
        *)
            firstConfig
            break
            ;;
        esac
    done
}

if [ ! -f "startconfig.cfg" ]; then
    setXmxNum=0
    setXmsNum=0
    configError=0
    firstConfig
fi

echo --------------- 正在读取已保存的配置... ---------------
setServerJarName=$(sed -n '1p' startconfig.cfg)
echo 设定的服务端文件名为：$setServerJarName。
setXmxNum=$(sed -n '2p' startconfig.cfg)
echo 设定的最大内存运行大小为：$setXmxNum MB。
setXmsNum=$(sed -n '3p' startconfig.cfg)
echo 设定的最小内存运行大小为：$setXmsNum MB。
setExtraJavaArgs=$(sed -n '4p' startconfig.cfg)
if [ $setExtraJavaArgs = ",,," ]; then
    echo 未设定的额外 Java 启动参数。
    setExtraJavaArgs=
else
    echo 设定的额外 Java 启动参数为：$setExtraJavaArgs。
fi
set3rdJavaPath=$(sed -n '5p' startconfig.cfg)
if [ $set3rdJavaPath == "java" ]; then
    echo 未设定自定义 Java。
else
    echo 设定的自定义 Java 路径为：$set3rdJavaPath。
fi

echo
echo --------------- 正在获取本机 IP 与端口... ---------------
nowIP=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
if [ -z $nowIP ]; then
    echo -- 获取 IP 失败
else
    echo -- 成功，IP 为：$nowIP
fi
Port=$(cat server.properties | grep server-port= | tr -d "seveport=\-")
if [ -z $Port ]; then
    echo -- 获取端口失败
else
    echo -- 成功，端口为：$Port
fi

echo
echo --------------- 正在验证文件... ---------------
if [ ! -f "$setServerJarName" ]; then
    echo 缺少 $setServerJarName！
    echo 检查服务端文件是否完整。
    echo 若初始配置时参数输入有误，请删除文件 startconfig.cfg 或直接打开修改。
    exit
else
    echo 服务端文件完整。
fi
if [ $set3rdJavaPath == "java" ]; then
    java -version
    if [ $? = 127 ]; then
        echo
        echo 未在您的计算机中找到 Java！
        echo 请前去软件包管理器或 Java 官方网站（java.com）下载最新版本的 Java。
        exit
    else
        echo Java 文件完整。
    fi
else
    if [ ! -f "$set3rdJavaPath" ]; then
        echo
        echo 未在您自定义的路径 "$set3rdJavaPath" 中找到 Java！
        echo 请前去软件包管理器或 Java 官方网站（java.com）下载最新版本的 Java。
        exit
    else
        echo Java 文件完整。
    fi
fi
echo -- 完整
echo

echo --------------- Minecraft $setServerJarName 服务端启动中... ---------------
echo 脚本版本：$mainVersion，IP: $nowIP:$Port，内存：$setXmsNum-$setXmxNum MB，键入stop或按Ctrl+C键可停止服务端
echo "$set3rdJavaPath" -Xms${setXmsNum}M -Xmx${setXmxNum}M $setExtraJavaArgs -jar $setServerJarName nogui
"$set3rdJavaPath" -Xms${setXmsNum}M -Xmx${setXmxNum}M $setExtraJavaArgs -jar $setServerJarName nogui
echo
echo --------------- Minecraft $setServerJarName 服务端已关闭... ---------------
echo Tips: 若要重新配置本启动器，直接删除 startconfig.cfg 并重启脚本即可。
if [ -f "eula.txt" ]; then
    eulaStatus=$(cat eula.txt | grep eula=)
    if [ ${eulaStatus:5} == false ]; then
        echo
        echo 您需要同意最终用户许可协议（EULA）才能运行服务器。
        echo 请前去 eula.txt 文件并将 “eula=false” 更改为 “eula=true” 以表明您同意 Mojang 的 EULA。
        echo 更多详情请参阅：https://account.mojang.com/documents/minecraft_eula
    fi
fi
if [ -a "Debug.ON" ]; then
    echo
    read -s -n1 -p "按任意键删除数据..."
    echo
    for debugFiles in $(cat Debug.ON | grep file:); do
        echo 正在删除文件 ${debugFiles:5}...
        rm -rf ${debugFiles:5}
    done
    for debugFolders in $(cat Debug.ON | grep folder:); do
        echo 正在删除文件夹 ${debugFolders:7}...
        rm -rf ${debugFolders:7}
    done
fi
