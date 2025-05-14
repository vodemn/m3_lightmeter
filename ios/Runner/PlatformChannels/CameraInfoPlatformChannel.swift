//
//  CameraInfoPlatformChannel.swift
//  Runner
//
//  Created by Vadim Turko on 2025-05-11.
//
import AVFoundation
import Flutter

public class CameraInfoPlatformChannel: NSObject {
    let methodChannel: FlutterMethodChannel
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        self.methodChannel = FlutterMethodChannel(
            name: "com.vodemn.lightmeter.CameraInfoPlatformChannel.MethodChannel",
            binaryMessenger: binaryMessenger
        )
        super.init()
        methodChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
                case "mainCameraEfl":
                    if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                        result(self.get35mmEquivalentFocalLength(format: device.activeFormat))
                    } else {
                        result(nil)
                    }
                default:
                    result(FlutterMethodNotImplemented)
            }
        })
    }
    
    func get35mmEquivalentFocalLength(format : AVCaptureDevice.Format) -> Float {
        // get reported field of view. Documentation says this is the horizontal field of view
        var fov = format.videoFieldOfView
        // convert to radians
        fov *= Float.pi/180.0
        // angle and opposite of right angle triangle are half the fov and half the width of
        // 35mm film (ie 18mm). The adjacent value of the right angle triangle is the equivalent
        // focal length. Using some right angle triangle math you can work out focal length
        let focalLen = 18 / tan(fov/2)
        return focalLen
    }
}
