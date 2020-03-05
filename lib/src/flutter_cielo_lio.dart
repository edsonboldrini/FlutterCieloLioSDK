part of flutter_cielo_lio_sdk;

class FlutterCieloLioSDK {
  static const _MESSAGE_CHANNEL = 'flutter_cielo_lio_sdk/message';
  static const _EVENT_CHANNEL = 'flutter_cielo_lio_sdk/event';

  static const int STATUS_NOME = 0;
  static const int STATUS_SUCCESS = 1;
  static const int STATUS_WITHOUT_PAPER = 2;

  static const MethodChannel _messageChannel =
      const MethodChannel(_MESSAGE_CHANNEL);

  static const EventChannel _eventChannel = const EventChannel(_EVENT_CHANNEL);

  static FlutterCieloLioSDK _singleton;

  /// Constructs a singleton instance of [FlutterCieloLioSDK].
  factory FlutterCieloLioSDK() {
    if (_singleton == null) {
      _singleton = FlutterCieloLioSDK._();
    }
    return _singleton;
  }

  FlutterCieloLioSDK._();

  static Stream<int> onPrinterListener() {
    return _eventChannel.receiveBroadcastStream().map((status) => status);
  }

  void printText({@required String text, Map<String, int> style}) {
    Map<String, dynamic> _params = {};
    _params['text'] = text;
    _params['style'] = style;
    _messageChannel.invokeMethod('printText', _params);
  }

  void printMultipleColumnText(
      {@required List<String> stringList, List<Map<String, int>> style}) {
    Map<String, dynamic> _params = {};
    _params['stringList'] = stringList;
    _params['style'] = style;
    //_messageChannel.invokeMethod('printMultipleColumnText', _params);
  }

  /*
  void printImage({@required List<int> bytes, Map<String, int> style}) {
    Map<String, dynamic> _params = {};
    _params['text'] = text;
    _params['style'] = style;
    _messageChannel.invokeMethod('printImage', _params);
  }
  */

  void printBarCode(
      {@required String text,
      int align,
      int width,
      int height,
      bool showContent}) {
    Map<String, dynamic> _params = {};
    _params['text'] = text;
    _params['align'] = align;
    _params['width'] = width;
    _params['height'] = height;
    _params['showContent'] = showContent;
    _messageChannel.invokeMethod('printBarCode', _params);
  }

  void printQrCode({@required String text, int align, int size}) {
    Map<String, dynamic> _params = {};
    _params['text'] = text;
    _params['align'] = align;
    _params['size'] = size;
    _messageChannel.invokeMethod('printQrCode', _params);
  }
}
