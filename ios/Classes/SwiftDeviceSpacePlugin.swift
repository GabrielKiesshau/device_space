import Flutter
import Foundation
import UIKit

public class SwiftDeviceSpacePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "device_space", binaryMessenger: registrar.messenger())
        let instance = SwiftDeviceSpacePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getFreeSpace" {
            do {
                let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())

                return result(attributes[FileAttributeKey.systemFreeSize] as! Int64)
            } catch {
                return result("")
            }
        } else if call.method == "getTotalSpace" {
            do {
                let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
                return result(attributes[FileAttributeKey.systemSize] as! Int64)
            } catch {
                return result("")
            }
        }
    }
}
