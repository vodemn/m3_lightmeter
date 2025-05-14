package com.vodemn.lightmeter

import android.os.Bundle
import android.view.KeyEvent
import androidx.core.view.WindowCompat
import com.vodemn.lightmeter.PlatformChannels.CaffeinePlatformChannel
import com.vodemn.lightmeter.PlatformChannels.CameraInfoPlatformChannel
import com.vodemn.lightmeter.PlatformChannels.VolumePlatformChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private val caffeinePlatformChannel = CaffeinePlatformChannel()
    private val cameraInfoPlatformChannel = CameraInfoPlatformChannel()
    private val volumePlatformChannel = VolumePlatformChannel()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        caffeinePlatformChannel.onAttachedToEngine(binaryMessenger, window)
        cameraInfoPlatformChannel.onAttachedToEngine(binaryMessenger, context)
        volumePlatformChannel.onAttachedToEngine(binaryMessenger)
    }

    override fun onDestroy() {
        caffeinePlatformChannel.onDestroy()
        cameraInfoPlatformChannel.onDestroy()
        volumePlatformChannel.onDestroy()
        super.onDestroy()
    }

    override fun onKeyDown(code: Int, event: KeyEvent): Boolean {
        return if (volumePlatformChannel.onKeyDown(code, event)) {
            true
        } else {
            super.onKeyDown(code, event)
        }
    }
}
