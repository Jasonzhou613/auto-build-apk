# windows下设置自动编译项目

##### 使用步骤（主要分为2步）
1. 配置config.properties文件
 - 设置项目名称 projectName，必填
 - 设置项目路径 projectPath，必填
 - 设置批处理文件路径 taskPath，必填
 - 设置编译后输出路径 outputPath
 - 设置编译并且签名后的app输出路径 signedApkDir
 - 设置mapping文件输入路径 mappingDir
 - 设置编译日志输出路径 logDir
 - 设置编译后的apk保存的时间，单位为（天）
 - 设置编译渠道号 gradleFlavor
 - 设置keystore路径 keystorePath
 - 设置keystore别名
 - 设置keystore别人的密码
2. 设置定时任务（这个大家可以在某度上搜出一大堆，这里就不多解释怎么去设置了）

------------

##### 批处理步骤解析（主要分为5步）
1. 当执行buildSetup.bat后，会脚本首先检查config.properties设置是否正确
2. 检查完设置后会执行checkExpiry.bat，该脚本会检查之前自动编译好的项目是否已经过期了，如果过期了则会被删除。设置保存时间的属性是：signedApkExpiryTime
3. 检查完后执行clean.bat来clean项目，便于之后的编译
4. clean完后执行build.bat，开始正在的编译工作
5. 编译完后执行signeApks.bat对app进行签名

------------
##### 所需要注意的问题
1. config.properties配置一定要设置正确，必填选项就必须填写，注意有些地方是使用绝对地址，有些地方是使用相对地址，配置错误的日志会保存到与taskPath同级的configErrorLogs目录下
2. windows下设置了定时任务后需要注意你是否按照了杀毒软件，如360会拦截你设置的定时任务，需要你添加信任
3. 默认情况下，编译过程log是不输出到屏幕上的而是直接保存到指定文件下的，如果需要看log则可以在config.properties中将debug的值设置为1