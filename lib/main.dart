import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:event_bus/event_bus.dart';

void main() {
  runApp(MyApp());
}

final eventBus = EventBus();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter 扫码Demo")),
      body: BodyContent(),
    );
  }
}

class BodyContent extends StatelessWidget {
  const BodyContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ScanButton(), ResultText()],
    ));
  }
}

class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: scan,
      child: const Text("调用扫码（需要手动打开摄像头权限）"),
    );
  }

  Future scan() async {
    String? cameraScanResult = await scanner.scan(); //通过扫码获取二维码中的数据
    final info = QRInfo("$cameraScanResult");
    eventBus.fire(info);
    print(cameraScanResult); //在控制台打印
  }
}

class ResultText extends StatefulWidget {
  @override
  _ResultTextState createState() => _ResultTextState();
}

class _ResultTextState extends State<ResultText> {
  String message = "此处显示扫码结果";

  @override
  void initState() {
    super.initState();

    eventBus.on<QRInfo>().listen((data) {
      setState(() {
        message = "${data.qrcode}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(fontSize: 18),
    );
  }
}

class QRInfo {
  String? qrcode;

  QRInfo(this.qrcode);
}
