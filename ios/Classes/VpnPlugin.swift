import Flutter
import UIKit

public class VpnPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vpn_plugin", binaryMessenger: registrar.messenger())
        let instance = VpnPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let stateChannel = FlutterEventChannel(name: "flutter_vpn_states", binaryMessenger: registrar.messenger())
        stateChannel.setStreamHandler((VPNStateHandler() as! FlutterStreamHandler & NSObjectProtocol))
        
        let errorsChannel = FlutterEventChannel(name: "errors_channel", binaryMessenger: registrar.messenger())
        errorsChannel.setStreamHandler((VpnErrorsHandler() as! FlutterStreamHandler & NSObjectProtocol))
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isEnabled":
            result(VpnService.shared.isEnabled)
        case "getConfiguredServerAddress":
            result(VpnService.shared.configuredServerAddress)
        case "getCurrentState":
            result(VpnService.shared.vpnStatus.rawValue)
        case "connect":
            let args = call.arguments! as! [NSString: NSString]
            VpnService.shared.connect(
                result: result,
                server: args["Server"]! as String,
                username: args["Username"]! as String,
                password: args["Password"]! as String,
                description: args["Name"] as? String
            )
        case "disconnect":
            VpnService.shared.disconnect()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
