import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vpn_plugin/state.dart';

import 'vpn_plugin_method_channel.dart';

abstract class VpnPluginPlatform extends PlatformInterface {
  /// Constructs a VpnPluginPlatform.
  VpnPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static VpnPluginPlatform _instance = MethodChannelVpnPlugin();

  /// The default instance of [VpnPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelVpnPlugin].
  static VpnPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VpnPluginPlatform] when
  /// they register themselves.
  static set instance(VpnPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Receive state change from VPN service.
  ///
  /// Can only be listened once. If have more than one subscription, only the
  /// last subscription can receive events.
  Stream<VpnState> get onStateChanged;

  /// Get current state.
  Future<VpnState> get currentState;

  /// Disconnect and stop VPN service.
  Future<void> disconnect();

  /// Connect to VPN. (IKEv2-EAP)
  ///
  /// This will create a background VPN service.
  /// MTU is only available on android.
  Future<void> connect({
    required String server,
    required String username,
    required String password,
    String? name,
  });

  /// Check is vpn enabled
  Future<bool> get isEnabled;

  /// Get connected config
  Future<String?> get configuredServerAddress;

  Stream<String> get onError;
}
