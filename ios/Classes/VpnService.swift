import Foundation
import NetworkExtension
import Flutter
import Security

class VpnService {
    static let shared: VpnService = {
        let instance = VpnService()
        return instance
    }()
    
    var vpnManager: NEVPNManager {
        get {
            return NEVPNManager.shared()
        }
    }
    
    var vpnStatus: NEVPNStatus {
        get {
            return vpnManager.connection.status
        }
    }
    
    var isEnabled: Bool {
        get {
            return vpnManager.isEnabled
        }
    }
    
    var configuredServerAddress: String? {
        get {
            vpnManager.protocolConfiguration?.serverAddress
        }
    }

    var connectedStartDateIso8601: String? {
        guard vpnManager.connection.connectedDate != nil else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 формат
        let dateString = formatter.string(from: vpnManager.connection.connectedDate!)

        return dateString
    }
    
    let kcs = KeychainService()
    
    var needToReconnect = false;
    
    init() {
        vpnManager.loadFromPreferences(completionHandler: {(error: Error?) -> Void in
            guard error == nil else {
                self.sendPreferencesError(msg: error?.localizedDescription)
                return
            }
        })
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: nil, queue: OperationQueue.main, using: statusChanged)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @available(iOS 9.0, *)
    func connect(
        result: @escaping FlutterResult,
        server: String,
        username: String,
        password: String,
        description: String?
    ){
        vpnManager.loadFromPreferences(completionHandler: {(error: Error?) -> Void in
            guard error == nil else {
                self.sendPreferencesError(msg: error?.localizedDescription)
                result(false)
                return
            }
            
            //IKEv2
            let passwordKey = "vpn_password_key"
            self.kcs.save(key: passwordKey, value: password)
            
            let p = NEVPNProtocolIKEv2()
            p.username = username
            p.remoteIdentifier = server
            p.serverAddress = server
            
            p.passwordReference = self.kcs.load(key: passwordKey)
            p.authenticationMethod = NEVPNIKEAuthenticationMethod.none
            
            p.useExtendedAuthentication = true
            p.disconnectOnSleep = false
            
            self.vpnManager.isEnabled = true
            self.vpnManager.isOnDemandEnabled = false
            self.vpnManager.localizedDescription = description
            self.vpnManager.protocolConfiguration = p
            
            self.vpnManager.saveToPreferences { (error) -> Void in
                guard error == nil else {
                    self.sendPreferencesError(msg: error?.localizedDescription)
                    result(false)
                    return
                }
                
                if self.vpnStatus == .invalid {
                    self.needToReconnect = true
                } else if self.vpnStatus == .connected || self.vpnStatus == .connecting {
                    self.needToReconnect = true
                    self.disconnect()
                } else {
                    self.startVpnTunnel()
                }
            }
        })
        
        result(nil)
    }
    
    func startVpnTunnel() {
        vpnManager.loadFromPreferences { (error) -> Void in
            guard error == nil else {
                self.sendPreferencesError(msg: error?.localizedDescription)
                return
            }
            
            do {
                try self.vpnManager.connection.startVPNTunnel()
            } catch let error as NSError {
                var errorStr = ""
                switch error {
                case NEVPNError.configurationDisabled:
                    errorStr = "The VPN configuration associated with the NEVPNManager is disabled."
                    break
                case NEVPNError.configurationInvalid:
                    errorStr = "The VPN configuration associated with the NEVPNManager object is invalid."
                    break
                case NEVPNError.configurationReadWriteFailed:
                    errorStr = "An error occurred while reading or writing the Network Extension preferences."
                    break
                case NEVPNError.configurationStale:
                    errorStr = "The VPN configuration associated with the NEVPNManager object was modified by some other process since the last time that it was loaded from the Network Extension preferences by the app."
                    break
                case NEVPNError.configurationUnknown:
                    errorStr = "An unspecified error occurred."
                    break
                case NEVPNError.connectionFailed:
                    errorStr = "The connection to the VPN server failed."
                    break
                default:
                    errorStr = "Unknown error: \(error.localizedDescription)"
                    break
                }
                
                let msg = "Start error: \(errorStr)"
                debugPrint(msg)
                VpnErrorsHandler.sendError(code: "Vpn Error. Connection.", errorMsg: msg)
                return;
            }
            
        }
        
    }
    
    func disconnect() {
        vpnManager.connection.stopVPNTunnel()
    }
    
    func sendPreferencesError(msg: String?) {
        VpnErrorsHandler.sendError(code: "Vpn Error. Preferences.", errorMsg: msg)
    }
    
    func statusChanged(_: Notification?) {
        VPNStateHandler.updateState(vpnStatus.rawValue)
        if vpnStatus == .disconnected && needToReconnect {
            self.startVpnTunnel()
            needToReconnect = false
        }
    }
}
