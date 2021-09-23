# MCServer_Starter
 Minecraft 服务器启动脚本
## 功能

 - 更好的配置服务器参数
 - 配置参数记忆功能
 - 支持联网查找下载最新服务端文件
## 支持的操作系统

系统|支持|已测试
---|---|---
Win 10 - Win 7|√|√
Win Vista以下|×|×
Ubuntu|√|√
Other Linux|√|×
MacOS|?|×
## 启动 Debug 模式

Q：何为 Debug 模式
A：启动 Debug 模式时可自动在服务器停止后删除指定的文件或文件夹
### 如何启动 Debug 模式
1.在本脚本所在的文件夹新建一个名为 Debug.ON 的文件
2.编写 Debug.ON 文件，格式如下
 - 文件：file:文件路径
 - 文件夹：folder:文件夹子路径
3.保存文件并启用脚本即可。

## 计划功能
 - Linux 脚本的下载服务端功能