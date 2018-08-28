# MinaOTP-MAC

[![](https://img.shields.io/badge/platform-osx-red.svg)](https://github.com/MinaOTP/MinaOTP-MAC)    [![](https://img.shields.io/github/release/MinaOTP/MinaOTP-MAC.svg)](https://github.com/MinaOTP/MinaOTP-MAC/releases)    [![](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/MinaOTP/MinaOTP-MTP)   
<!-- [![](https://img.shields.io/github/downloads/MinaOTP/MinaOTP-MAC/latest/total.svg)](https://github.com/MinaOTP/MinaOTP-MAC)
-->
MinaOTP-MAC 是一款运行在macOS上的App. 是基于[RFC6238](https://tools.ietf.org/html/rfc6238)算法, 算法实现语言是 `Objective-C`。App功能开发基于Swift

该App能够很方便的为你提供二步验证码。包括对Token的添加、编辑、删除、导入、导出等功能

## 依赖

- macOS 10.10+
- Xcode 9.4.1+
- Swift 4.1

### 软件截图

首页

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/guide_en_10.png)

鼠标右键点击弹出删除和编辑

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/guide_en_09.jpeg)

编辑

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/guide_en_05.png)

鼠标右键点击状态栏Icon弹出帮助页面

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/guide_en_07.png)

添加Token

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/guide_en_08.jpeg)

扫描二维码

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/guide_en_02.png)
![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/guide_en_03.png)


### 功能

* 生成 2FA token
* 选择一个二维码图片，识别并添加
* 扫描一个二维码图片，识别并添加
* 手动添加
* 编辑所有信息
* 删除
* 导出token信息，生成本地的Json文件
* 从本地的Json文件，添加Token信息
* 快捷键:   ⌘⌘   (双击 ⌘ 键) 

### 将来
* [ ] 同步到icloud 
* [ ] 添加快捷键用来复制token 

### 感谢
[FlatButton](https://github.com/OskarGroth/FlatButton)
[Magnet](https://github.com/Clipy/Magnet)
Thanks for their great work. 

### [README](README.md)