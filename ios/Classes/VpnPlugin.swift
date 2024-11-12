import Flutter
import UIKit

public class VpnPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vpn_plugin", binaryMessenger: registrar.messenger())
        let instance = VpnPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isEnabled":
            result(VpnService.shared.isEnabled)
        case "getConnectedServer":
            result(VpnService.shared.connectedServerAddress)
        case "getCurrentState":
            result(VpnService.shared.vpnStatus)
        case "disconnect":
            let args = call.arguments! as! [NSString: NSString]
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
