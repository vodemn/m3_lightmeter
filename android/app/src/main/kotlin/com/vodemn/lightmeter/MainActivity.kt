package com.vodemn.lightmeter

import android.os.Bundle
import android.view.KeyEvent
import android.view.WindowManager
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var keepScreenOnChannel: MethodChannel
    private lateinit var volumeHandlingChannel: MethodChannel
    private lateinit var volumeEventChannel: EventChannel
    private var volumeEventsEmitter: EventSink? = null
    private var handleVolume = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        keepScreenOnChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.vodemn.lightmeter/keepScreenOn"
        )
        keepScreenOnChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isKeepScreenOn" -> result.success((window.attributes.flags and WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) != 0)
                "setKeepScreenOn" -> {
                    if (call.arguments !is Boolean) {
                        result.error("invalid args", "Argument should be of type Bool for 'setKeepScreenOn' call", null)
                    } else {
                        if (call.arguments as Boolean) window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        else window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        result.success(true)
                    }
                }
                else -> result.notImplemented()
            }
        }

        volumeHandlingChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.vodemn.lightmeter/volumeHandling"
        )
        volumeHandlingChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "setVolumeHandling" -> {
                    handleVolume = call.arguments as Boolean
                    result.success(handleVolume)
                }
                else -> result.notImplemented()
            }
        }

        volumeEventChannel = EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.vodemn.lightmeter/volumeEvents"
        )
        volumeEventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(listener: Any?, eventSink: EventSink) {
                volumeEventsEmitter = eventSink
            }
            override fun onCancel(listener: Any?) {
                volumeEventsEmitter = null
            }
        })
    }

    override fun onDestroy() {
        keepScreenOnChannel.setMethodCallHandler(null)
        volumeHandlingChannel.setMethodCallHandler(null)
        volumeEventChannel.setStreamHandler(null)
        super.onDestroy()
    }

    override fun onKeyDown(code: Int, event: KeyEvent): Boolean {
        return when (val keyCode: Int = event.keyCode) {
            KeyEvent.KEYCODE_VOLUME_UP, KeyEvent.KEYCODE_VOLUME_DOWN -> {
                if (handleVolume) {
                    volumeEventsEmitter?.success(keyCode)
                    true
                } else {
                    super.onKeyDown(code, event)
                }
            }
            else -> super.onKeyDown(code, event)
        }
    }
}
