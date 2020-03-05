import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cielo_lio_sdk/flutter_cielo_lio_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: RaisedButton(
          onPressed: _print,
          child: Text('Imprimir'),
        )),
      ),
    );
  }

  void _print() async {
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

    //////////////////////////////////////////////////////////////////////
    FlutterCieloLioSDK.printText(
        text: 'Texto simples a ser impresso.\n Com múltiplas linhas',
        style: alignLeft);

    List<String> textsToPrint = [
      "Texto alinhado à esquerda.",
      "Texto centralizado",
      "Texto alinhado à direita"
    ];
    //////////////////////////////////////////////////////////////////////
    List<Map<String, int>> stylesMap = [{}];

    stylesMap.add(alignLeft);
    stylesMap.add(alignCenter);
    stylesMap.add(alignRight);

    FlutterCieloLioSDK.printMultipleColumnText(
        stringList: textsToPrint, style: stylesMap);

    FlutterCieloLioSDK.printBarCode(
        text: '1234567890098765432112345678900987654321',
        align: PrinterAttributes.VAL_ALIGN_CENTER,
        width: 500,
        height: 200,
        showContent: false);

    //////////////////////////////////////////////////////////////////////

    FlutterCieloLioSDK.printQrCode(
        text: "1234567890098765432112345678900987654321",
        align: PrinterAttributes.VAL_ALIGN_CENTER,
        size: 500);

    //////////////////////////////////////////////////////////////////////
    final ByteData bytes = await rootBundle.load('images/logo.png');
    FlutterCieloLioSDK.printImage(
        name: 'logo.png',
        bytes: bytes.buffer.asUint8List(),
        style: alignCenter);
  }
}
