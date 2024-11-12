import Foundation
import NetworkExtension
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
    
    var connectedServerAddress: String? {
        get {
            vpnManager.protocolConfiguration?.serverAddress
        }
    }
    
    let kcs = KeychainService()
    
    init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: nil, queue: OperationQueue.main, using: statusChanged)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @available(iOS 9.0, *)
    func connect(
        result: FlutterResult,
        type: String,
        server: String,
        username: String,
        password: String,
        secret: String?,
        description: String?
    ){
        
    }
    
    func statusChanged(_: Notification?) {
        VPNStateHandler.updateState(vpnStatus.rawValue)
    }
}
