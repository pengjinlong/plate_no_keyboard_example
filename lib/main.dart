import 'package:flutter/material.dart';
import 'package:plate_no_keyboard_example/components/plate_no_keyboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '车牌号键盘输入demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '车牌号键盘输入demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String plateNo = '';

  keyboardClose(String plate) {
    setState(() {
      plateNo = plate;
    });
  }

  itemClick() {
    print('震动一次');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                PlateNoKeyboard(context: context, plateNo: plateNo, onClose: keyboardClose).show();
              },
              child: Text('点击输入车牌号'),
            ),
            Text('车牌号是：$plateNo')
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
