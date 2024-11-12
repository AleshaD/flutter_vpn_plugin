import 'package:vpn_plugin/state.dart';

import 'vpn_plugin_platform_interface.dart';

abstract class VpnPlugin {
  static Future<void> connect({
    required String server,
    required String username,
    required String password,
    String? name,
    int? mtu,
    int? port,
  }) async {
    VpnPluginPlatform.instance.connect(
      server: server,
      username: username,
      password: password,
      name: name,
    );
  }

  static Future get connectedServer =>
      VpnPluginPlatform.instance.connectedServer;

  static Future<VpnState> get currentState =>
      VpnPluginPlatform.instance.currentState;

  static Future<void> disconnect() async {
    VpnPluginPlatform.instance.disconnect();
  }

  static Future<bool> get isEnabled => VpnPluginPlatform.instance.isEnabled;

  static Stream<VpnState> get onStateChanged =>
      VpnPluginPlatform.instance.onStateChanged;
}
