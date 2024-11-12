enum VpnState {
  /// @const NEVPNStatusInvalid The VPN is not configured.
  invalid,

  /// @const NEVPNStatusDisconnected The VPN is disconnected.
  disconnected,

  /// @const NEVPNStatusConnecting The VPN is connecting.
  connecting,

  /// @const NEVPNStatusConnected The VPN is connected.
  connected,

  /// @const NEVPNStatusReasserting The VPN is reconnecting following loss of underlying network connectivity.
  reasserting,

  /// @const NEVPNStatusDisconnecting The VPN is disconnecting.
  disconnecting,

  error;
}
