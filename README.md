# MinaOTP-MAC

[![](https://img.shields.io/badge/platform-osx-red.svg)](https://github.com/MinaOTP/MinaOTP-MAC)    [![](https://img.shields.io/github/release/MinaOTP/MinaOTP-MAC.svg)](https://github.com/MinaOTP/MinaOTP-MAC/releases)    [![](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/MinaOTP/MinaOTP-MTP)   
<!-- [![](https://img.shields.io/github/downloads/MinaOTP/MinaOTP-MAC/latest/total.svg)](https://github.com/MinaOTP/MinaOTP-MAC)
-->
MinaOTP-MAC is a two-factor authentication tray app that runs at macOS. It's based on [RFC6238](https://tools.ietf.org/html/rfc6238), and the algorithm was implement by `Objective-C`

The program will generate secure dynamic 2FA tokens for you, and the `add`, `edit`, `remove`,`import`, `export` are pretty convenient.

## Requirements

- macOS 10.10+
- Xcode 9.4.1+
- Swift 4.1

### Software Screenshot

Home

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/MinaOtp-Guide0.png)

Manual entry

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/MinaOtp-Guide1.png)

Delete

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/MinaOtp-Guide2.png)

Help

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/MinaOtp-Guide3.png)

Edit

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/MinaOtp-Guide5.png)

Export

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/MinaOtp-Guide7.png)

Add Token

![screenshot](https://raw.githubusercontent.com/wjmwjmwb/GitImage/master/MinaOtp-Guide/MinaOtp-Guide8.png)


### Feature

* Generate the 2FA token
* Choose a qrcode_image to add a new token
* Add a new token mannually
* Edit the issuer and remark info
* Remove a existed token
* Backup datas to local json files
* Import datas from local json files
* Hotkey:   ⌘⌘   (double click ⌘) 

### Todo
* [ ] sync to icloud
* [ ] add hotkey to copy token 