package br.com.rsmarques.flutter_cielo_lio_sdk;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import androidx.annotation.NonNull;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cielo.sdk.order.PrinterListener;
import cielo.sdk.printer.PrinterManager;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

class PrinterStatus {
    static int SUCCESS = 1;
    static int WITHOUT_PAPER = 2;
}

/**
 * FlutterCieloLioSdkPlugin
 */
public class FlutterCieloLioSdkPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private static PrinterManager printerManager;
    private static PrinterListener printerListener;

    private static HashMap<String, Integer> alignCenter = new HashMap<>();
    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private static final String MESSAGE_CHANNEL = "flutter_cielo_lio_sdk/message";
    private static final String EVENT_CHANNEL = "flutter_cielo_lio_sdk/event";
    private EventChannel.EventSink eventSink = null;
    private static final String DEBUG_NAME = "flutter_lio_sdk";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.d(DEBUG_NAME, "onAttachedToEngine");
        setupChannels(flutterPluginBinding.getFlutterEngine().getDartExecutor(), flutterPluginBinding.getApplicationContext());
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        Log.d(DEBUG_NAME, "registerWith");
        FlutterCieloLioSdkPlugin plugin = new FlutterCieloLioSdkPlugin();
        plugin.setupChannels(registrar.messenger(), registrar.activity().getApplicationContext());
    }

    private void setupChannels(BinaryMessenger messenger, Context context) {
        methodChannel = new MethodChannel(messenger, MESSAGE_CHANNEL);
        eventChannel = new EventChannel(messenger, EVENT_CHANNEL);

        methodChannel.setMethodCallHandler(this);
        eventChannel.setStreamHandler(this);

        printerManager = new PrinterManager(context);
        printerListener = new PrinterListener() {
            @Override
            public void onWithoutPaper() {
                Log.d(DEBUG_NAME, "printer without paper");
                if (eventSink != null) {
                    eventSink.success(PrinterStatus.WITHOUT_PAPER);
                }
            }

            @Override
            public void onPrintSuccess() {
                Log.d(DEBUG_NAME, "print success!");
                if (eventSink != null) {
                    eventSink.success(PrinterStatus.SUCCESS);
                }
            }

            @Override
            public void onError(Throwable throwable) {
                Log.d(DEBUG_NAME, String.format("printer error -> %s", throwable.getMessage()));
                if (eventSink != null) {
                    eventSink.error("-999", throwable.getMessage(), null);
                }
            }
        };
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "printText":
                printText(call);
                break;
            case "printMultipleColumnText":
                printMultipleColumnText(call);
                break;
            case "printImage":
                printImage(call);
                break;
            case "printBarCode":
                printBarCode(call);
                break;
            case "printQrCode":
                printQrCode(call);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object arguments) {
        this.eventSink = null;
    }

    private void printText(MethodCall call) {
        HashMap<String, Object> argsMap = (HashMap<String, Object>) call.arguments;
        String text = (String) argsMap.get("text");
        Map<String, Integer> style = (Map<String, Integer>) argsMap.get("style");

        printerManager.printText(text, style, printerListener);
    }

    private void printMultipleColumnText(MethodCall call) {
        HashMap<String, Object> argsMap = (HashMap<String, Object>) call.arguments;
        ArrayList<String> stringArray = (ArrayList<String>) argsMap.get("stringList");
        String[] stringColumns = new String[stringArray.size()];
        stringColumns = stringArray.toArray(stringColumns);
        List<Map<String, Integer>> style = (List<Map<String, Integer>>) argsMap.get("style");

        printerManager.printMultipleColumnText(stringColumns, style, printerListener);
    }

    private void printImage(MethodCall call) {
        HashMap<String, Object> argsMap = (HashMap<String, Object>) call.arguments;
        String fileName = (String) argsMap.get("name");
        Bitmap bitmap = BitmapFactory.decodeFile(fileName);
        Map<String, Integer> style = (Map<String, Integer>) argsMap.get("style");

        printerManager.printImage(bitmap, style, printerListener);
    }

    private void printBarCode(@NonNull MethodCall call) {
        HashMap<String, Object> argsMap = (HashMap<String, Object>) call.arguments;
        String text = (String) argsMap.get("text");
        int align = (int) argsMap.get("align");
        int width = (int) argsMap.get("width");
        int height = (int) argsMap.get("height");
        boolean showContent = (boolean) argsMap.get("showContent");

        printerManager.printBarCode(text, align, width, height, showContent,printerListener);
    }

    private void printQrCode(@NonNull MethodCall call) {
        HashMap<String, Object> argsMap = (HashMap<String, Object>) call.arguments;
        String text = (String) argsMap.get("text");
        int align = (int) argsMap.get("align");
        int size = (int) argsMap.get("size");

        printerManager.printQrCode(text, align, size, printerListener);
    }
}
