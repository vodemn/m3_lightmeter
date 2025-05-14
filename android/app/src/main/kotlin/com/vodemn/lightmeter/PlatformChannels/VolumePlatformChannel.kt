package com.vodemn.lightmeter.PlatformChannels

import android.view.KeyEvent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel

/** VolumePlatformChannel */
class VolumePlatformChannel {
    private lateinit var volumeMethodChannel: MethodChannel
    private lateinit var volumeEventChannel: EventChannel
    private var volumeEventsEmitter: EventSink? = null
    private var handleVolume = false

    fun onAttachedToEngine(binaryMessenger: BinaryMessenger) {
        volumeMethodChannel = MethodChannel(
            binaryMessenger,
            "com.vodemn.lightmeter.VolumePlatformChannel.MethodChannel"
        )
        volumeMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "setVolumeHandling" -> {
                    handleVolume = call.arguments as Boolean
                    result.success(handleVolume)
                }

                else -> result.notImplemented()
            }
        }

        volumeEventChannel = EventChannel(
            binaryMessenger,
            "com.vodemn.lightmeter.VolumePlatformChannel.EventChannel"
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

    fun onDestroy() {
        volumeMethodChannel.setMethodCallHandler(null)
        volumeEventChannel.setStreamHandler(null)
    }

    fun onKeyDown(code: Int, event: KeyEvent): Boolean {
        return when (val keyCode: Int = event.keyCode) {
            KeyEvent.KEYCODE_VOLUME_UP, KeyEvent.KEYCODE_VOLUME_DOWN -> {
                if (handleVolume) {
                    volumeEventsEmitter?.success(keyCode)
                    true
                } else {
                    false
                }
            }

            else -> false
        }
    }
}