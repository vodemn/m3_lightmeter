import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let caffeinePlatformChannel = CaffeinePlatformChannel(binaryMessenger: controller.binaryMessenger)
        let cameraInfoPlatformChannel = CameraInfoPlatformChannel(binaryMessenger: controller.binaryMessenger)
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
