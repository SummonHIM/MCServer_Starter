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

注意：若要将服务器从Windows迁移至Linux，或Linux迁移至Windows。请注意 startconfig.cfg 与 eula.txt 文件的编码。避免造成编码错误导致的脚本错误。若出现编码问题，请尝试转码或删除上述文件。

Bat推荐编码：GBK，行尾：CRLF

Sh推荐编码：UTF-8，行尾：LF
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