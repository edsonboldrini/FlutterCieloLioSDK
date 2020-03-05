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

    Map<String, int> alignLeft = {};
    Map<String, int> alignCenter = {};
    Map<String, int> alignRight = {};

    alignLeft[PrinterAttributes.KEY_ALIGN] = PrinterAttributes.VAL_ALIGN_LEFT;
    alignLeft[PrinterAttributes.KEY_TYPEFACE] = 0;
    alignLeft[PrinterAttributes.KEY_TEXT_SIZE] = 20;

    alignCenter[PrinterAttributes.KEY_ALIGN] =
        PrinterAttributes.VAL_ALIGN_CENTER;
    alignCenter[PrinterAttributes.KEY_TYPEFACE] = 1;
    alignCenter[PrinterAttributes.KEY_TEXT_SIZE] = 20;

    alignRight[PrinterAttributes.KEY_ALIGN] = PrinterAttributes.VAL_ALIGN_RIGHT;
    alignRight[PrinterAttributes.KEY_TYPEFACE] = 2;
    alignRight[PrinterAttributes.KEY_TEXT_SIZE] = 20;

    cielolio.printText(
        text: 'Texto simples a ser impresso.\n Com múltiplas linhas',
        style: alignLeft);

    List<String> textsToPrint = [
      "Texto alinhado à esquerda.",
      "Texto centralizado",
      "Texto alinhado à direita"
    ];

    List<Map<String, int>> stylesMap = [{}];

    stylesMap.add(alignLeft);
    stylesMap.add(alignCenter);
    stylesMap.add(alignRight);

    cielolio.printMultipleColumnText(
        stringList: textsToPrint, style: stylesMap);
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
