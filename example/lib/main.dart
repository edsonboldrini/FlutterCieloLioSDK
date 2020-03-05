import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cielo_lio_sdk/flutter_cielo_lio_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  FlutterCieloLioSDK cielolio = FlutterCieloLioSDK();

  @override
  void initState() {
    super.initState();

    FlutterCieloLioSDK.onPrinterListener().listen((status) {
      switch (status) {
        case FlutterCieloLioSDK.STATUS_SUCCESS:
          print('sucess');
          break;
        case FlutterCieloLioSDK.STATUS_WITHOUT_PAPER:
          print('sem papel');
          break;
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });

    cielolio.printText(
      text: 'text',
    );

    cielolio.printMultipleColumnText(stringList: null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
