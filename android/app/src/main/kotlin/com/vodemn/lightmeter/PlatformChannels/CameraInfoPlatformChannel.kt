package com.vodemn.lightmeter.PlatformChannels

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CameraMetadata.LENS_FACING_BACK
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.math.pow
import kotlin.math.sqrt

/** CameraInfoPlatformChannel */
class CameraInfoPlatformChannel : MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var cameraManager: CameraManager
    private var mainCameraEfl: Double? = null

    fun onAttachedToEngine(binaryMessenger: BinaryMessenger, context: Context) {
        channel = MethodChannel(binaryMessenger, "com.vodemn.lightmeter.CameraInfoPlatformChannel")
        cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "mainCameraEfl" -> {
                mainCameraEfl = mainCameraEfl ?: getMainCameraFocalLength35mm()
                result.success(mainCameraEfl)
            }
            else -> result.notImplemented()
        }
    }

    fun onDestroy() {
        channel.setMethodCallHandler(null)
    }

    private fun getMainCameraFocalLength35mm(): Double? {
        return cameraManager.cameraIdList.map {
            cameraManager.getCameraCharacteristics(it)
        }.first {
            it.get(CameraCharacteristics.LENS_FACING) == LENS_FACING_BACK
        }.focalLength35mm()
    }

    private fun CameraCharacteristics.focalLength35mm(): Double? {
        val defaultFocalLength = get(CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS)?.first()
        val sensorSize = get(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE)
        return if (defaultFocalLength != null && sensorSize != null) {
            // https://en.wikipedia.org/wiki/35_mm_equivalent_focal_length#Conversions
            43.27 * defaultFocalLength / sqrt(sensorSize.height.pow(2) + sensorSize.width.pow(2))
        } else {
            null
        }
    }
}
