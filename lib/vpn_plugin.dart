import 'package:vpn_plugin/state.dart';

import 'vpn_plugin_platform_interface.dart';

abstract class VpnPlugin {
  static Future<void> connect({
    required String server,
    required String username,
    required String password,
    String? name,
  }) async {
    VpnPluginPlatform.instance.connect(
      server: server,
      username: username,
      password: password,
      name: name,
    );
  }

  static Future<String?> get configuredServerAddress =>
      VpnPluginPlatform.instance.configuredServerAddress;

  static Future<VpnState> get currentState =>
      VpnPluginPlatform.instance.currentState;

  static Future<void> disconnect() async {
    VpnPluginPlatform.instance.disconnect();
  }

  static Future<bool> get isEnabled => VpnPluginPlatform.instance.isEnabled;

  static Future<DateTime?> get connectedStartDate =>
      VpnPluginPlatform.instance.connectedStartDate;

  static Stream<VpnState> get onStateChanged =>
      VpnPluginPlatform.instance.onStateChanged;

  static Stream<String> get onError => VpnPluginPlatform.instance.onError;
}
