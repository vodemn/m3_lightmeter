import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let keepScreenOnChannel = FlutterMethodChannel(name: "com.vodemn.lightmeter/keepScreenOn",
                                                  binaryMessenger: controller.binaryMessenger)
        keepScreenOnChannel.setMethodCallHandler({
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
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
