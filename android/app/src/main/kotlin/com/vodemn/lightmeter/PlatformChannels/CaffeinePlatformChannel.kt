package com.vodemn.lightmeter.PlatformChannels

import android.view.Window
import android.view.WindowManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** CaffeinePlatformChannel */
class CaffeinePlatformChannel {
    private lateinit var channel: MethodChannel

    fun onAttachedToEngine(binaryMessenger: BinaryMessenger, window: Window) {
        channel = MethodChannel(
            binaryMessenger,
            "com.vodemn.lightmeter.CaffeinePlatformChannel.MethodChannel"
        )
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isKeepScreenOn" -> result.success((window.attributes.flags and WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) != 0)
                "setKeepScreenOn" -> {
                    if (call.arguments !is Boolean) {
                        result.error(
                            "invalid args",
                            "Argument should be of type Bool for 'setKeepScreenOn' call",
                            null
                        )
                    } else {
                        if (call.arguments as Boolean) window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        else window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        result.success(true)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    fun onDestroy() {
        channel.setMethodCallHandler(null)
    }
}
