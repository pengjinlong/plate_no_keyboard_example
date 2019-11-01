## 车牌号输入键盘flutter组件

***

### 使用
> 注意，本仓库是一个运行demo，并非插件。如果要使用到自己的项目中，请自行去lib/components文件夹中提取文件，使用方法同下

### 在页面中引入
```
import 'package:app_flutter/widgets/plate_no_keyboard.dart';
```
### 在点击事件中调用
```
PlateNoKeyboard(context: context, plateNo: plateNo, onClose: keyboardClose).show();
```

参数| 含义
---- | ---
context | Buildcontext
plateNo |  车牌号
onClose | 键盘关闭事件回调
itemClick | 按钮点击事件回调（可选，用于需要给点击按钮加震动反馈效果处理）

### 函数处理例子
```
keyboardClose(String plate) {
    setState(() {
      plateNo = plate;
    });
  }
```
```
itemClick() {
    print('震动一次');
 }
```
### 相关博客
[手把手教你，用flutter实现车牌号输入键盘组件]()