//
//  CaffeinePlatformChannel.swift
//  Runner
//
//  Created by Vadim Turko on 2025-05-11.
//
import Flutter

public class CaffeinePlatformChannel: NSObject {
    let methodChannel: FlutterMethodChannel
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        self.methodChannel = FlutterMethodChannel(
            name: "com.vodemn.lightmeter.CaffeinePlatformChannel.MethodChannel",
            binaryMessenger: binaryMessenger
        )
        super.init()
        methodChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
                case "isKeepScreenOn":
                    result(UIApplication.shared.isIdleTimerDisabled)
                case "setKeepScreenOn":
                    guard let keepOn = call.arguments as? Bool else {
                        result(FlutterError(code: "invalid arguments", message: "Argument should be of type Bool for 'setKeepScreenOn' call", details: nil))
                        return
                    }
                    UIApplication.shared.isIdleTimerDisabled = keepOn
                    result(true)
                default:
                    result(FlutterMethodNotImplemented)
            }
        })
        
    }
}
