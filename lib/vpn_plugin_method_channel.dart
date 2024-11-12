import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vpn_plugin/state.dart';

import 'vpn_plugin_platform_interface.dart';

/// An implementation of [VpnPluginPlatform] that uses method channels.
class MethodChannelVpnPlugin extends VpnPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('vpn_plugin');

  @visibleForTesting
  final eventChannel = const EventChannel('flutter_vpn_states');

  @visibleForTesting
  final errorsChannel = const EventChannel('errors_channel');

  @override
  Future<void> connect(
      {required String server,
      required String username,
      required String password,
      String? name,
      int? mtu,
      int? port}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> get connectedServer =>
      methodChannel.invokeMethod('getConnectedServer');

  @override
  Future<VpnState> get currentState async {
    final state = await methodChannel.invokeMethod<int?>('getCurrentState');
    assert(state != null, 'Received a null state from `getCurrentState` call.');
    return VpnState.values[state!];
  }

  @override
  Future<void> disconnect() async {
    methodChannel.invokeMethod('disconnect');
  }

  @override
  Future<bool> get isEnabled async {
    return (await methodChannel.invokeMethod<bool>('isEnabled')) ?? false;
  }

  @override
  Stream<VpnState> get onStateChanged =>
      eventChannel.receiveBroadcastStream().map((e) => VpnState.values[e]);

  @override
  Stream get onError => errorsChannel.receiveBroadcastStream();
}
