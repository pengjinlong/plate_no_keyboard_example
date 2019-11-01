import 'package:flutter/material.dart';

const PROVINCES = ['京', '沪', '津', '渝', '冀', '晋','蒙', '辽', '吉', '黑', '苏', '浙','皖', '闽', '赣', '鲁', '豫', '鄂','湘', '粤', '桂', '琼', '川', '贵',
  '云', '藏', '陕', '甘', '青', '宁','新'];
const ALPHABETS = ['A', 'B', 'C', 'D', 'E', 'F','G', 'H', 'I', 'J', 'K', 'L','M', 'N', 'O', 'P', 'Q', 'R',
  'S', 'T', 'U', 'V', 'W', 'X','Y', 'Z','0', '1', '2', '3','4', '5', '6', '7', '8', '9','学','警', '挂',];
const CONTENT_HEIGHT = { 'province': 320.0, 'alphabet': 365.0 };

class PlateNoKeyboard {
  final BuildContext context;
  final String plateNo;
  final Function onClose;
  final Function itemClick;

  PlateNoKeyboard({
    @required this.context,
    @required this.plateNo,
    @required this.onClose,
    this.itemClick,
  });

  Future<bool> show() async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return _buildContent;
      },
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5), // 设置背景颜色
      transitionDuration: Duration(milliseconds: 400),
      transitionBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) =>
          fromBottom(animation, secondaryAnimation, child),
    );
  }

  Widget get _buildContent {
    // 改变车牌号需要刷新页面，所以这里必须返回一个StatefulWidget包裹的内容
    return KeyboardContent(plateNo: plateNo, onClose: onClose, itemClick: itemClick,);
  }
  // 从下往上弹出动画效果
  fromBottom(Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class KeyboardContent extends StatefulWidget {
  final String plateNo;
  final Function onClose;
  final Function itemClick;

  const KeyboardContent({
    Key key,
    @required this.plateNo,
    @required this.onClose,
    this.itemClick,
  }): super(key: key);
  @override
  _KeyboardContentState createState() => _KeyboardContentState();
}

class _KeyboardContentState extends State<KeyboardContent> {
  String _plate;
  String _toastValue = '';
  bool _showToast = false;
  double _toastLeft = 0.0;
  double _toastTop = 0.0;
  double _btnWidth = 0.0;
  double _bodyWidth = 0.0;
  List _data;
  double _contentHeight;
  GlobalKey _bodyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _plate = widget.plateNo;
    if (widget.plateNo.length > 0) {
      _data = ALPHABETS;
      _contentHeight = CONTENT_HEIGHT['alphabet'];
    } else {
      _data = PROVINCES;
      _contentHeight = CONTENT_HEIGHT['province'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Text(''),),
              _resultPanel,
              Padding(padding: EdgeInsets.only(bottom: 10),),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xffD3D6DB),
                  ),
                  child: Column(
                    children: <Widget>[
                      _keyboardHead,
                      Padding(padding: EdgeInsets.only(bottom: 6),),
                      Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          _keyboardBody,
                          _showToast ? _toastView : Text(''),
                        ],
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
      onWillPop: () {
        widget.onClose(_plate);
        Navigator.pop(context);
        return Future.value(false);
      },
    );
  }

  Container get _line {
    return Container(
      width: 10,
      height: 2,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
      ),
    );
  }

  Container _wrapButton(FlatButton flatButton) {
    return Container(
      width: 56,
      height: 45,
      decoration: BoxDecoration(
          color: Color(0xffB0B6BF),
          borderRadius: BorderRadius.circular(8)
      ),
      child: flatButton,
    );
  }

  Positioned get _toastView {
    return Positioned(
      top: _toastTop,
      left: _toastLeft,
      child: Container(
          width: _btnWidth,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(_toastValue, style: TextStyle(color: Colors.white, fontSize: 18),),
          )
      ),
    );
  }

  Container get _resultPanel {
    return Container(
      width: 230,
      height: 75,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: 20,
            top: 6,
            child: _line,
          ),Positioned(
            right: 20,
            top: 6,
            child: _line,
          ),Positioned(
            left: 20,
            bottom: 6,
            child: _line,
          ),Positioned(
            right: 20,
            bottom: 6,
            child: _line,
          ),
          Positioned(
            child: Text(_plate, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
          ),

        ],
      ),
    );
  }

  Row get _keyboardHead {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _wrapButton(
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: (){
              widget.onClose(_plate);
              Navigator.pop(context);
            },
            child: Text('取消', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        Text('选择车牌号', style: TextStyle(fontSize: 18, color: Color(0xff333333), fontWeight: FontWeight.bold),),
        _wrapButton(
          FlatButton(
            onPressed: (){
              int len = _plate.length;
              if (len > 0) {
                setState(() {
                  _plate = _plate.substring(0, len - 1);
                });
                if (_plate.length < 1) {
                  setState(() {
                    _data = PROVINCES;
                    _contentHeight = CONTENT_HEIGHT['province'];
                  });
                }
              }
            },
            child: Icon(Icons.clear, size: 24, color: Color(0xff333333),),
          ),
        ),
      ],
    );
  }

  _handleToast(int index) async {
    if (_btnWidth == 0.0) {
      // 缓存值，不必每次点击执行
      double bodyWidth = _bodyKey.currentContext.size.width;
      double btnWidth = (bodyWidth - 30) / 6;
      setState(() {
        _btnWidth = btnWidth;
        _bodyWidth = bodyWidth;
      });
    }

    int left = (index + 1) % 6; // 第几列
    int top = (index/6).floor(); // 第几行
    setState(() {
      _toastTop = top * 45.0 - 30;
      if (left == 0) {
        _toastLeft = _bodyWidth - _btnWidth;
      } else if (left == 1) {
        _toastLeft = 0;
      } else {
        _toastLeft = (left - 1) * (_btnWidth + 6);
      }
      _toastValue = _data[index];
      _showToast = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _showToast = false;
    });
    if (_plate.length == 7) {
      // 车牌号达到七位数自动关闭键盘
      widget.onClose(_plate);
      Navigator.pop(context);
    }
  }

  Container get _keyboardBody {
    return Container(
      key: _bodyKey,
      height: _contentHeight,
      child: GridView.count(
        crossAxisSpacing: 7,
        mainAxisSpacing: 6,
        crossAxisCount: 6,
        childAspectRatio: 1.24,
        children: List.generate(_data.length, (index) {
          return FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
            color: Colors.white,
            highlightColor: Colors.blueAccent,
            splashColor: Colors.blueAccent,
            child: Text(_data[index], style: TextStyle(color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.bold),),
            onPressed:() {
              if (_plate.length < 7) {
                setState(() {
                  _plate = _plate + _data[index];
                });
                widget.itemClick != null ? widget.itemClick() : ''; // 这里不能使用widget?.itemClick()及widget.itemClick != null && widget.itemClick()写法，会报错
                _handleToast(index);
              }
              if (_plate.length == 1) {
                setState(() {
                  _data = ALPHABETS;
                  _contentHeight = CONTENT_HEIGHT['alphabet'];
                });
              }
            },
          );
        }),
      ),
    );
  }
}