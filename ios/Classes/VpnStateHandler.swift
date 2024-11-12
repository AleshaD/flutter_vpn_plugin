//
//  VpnStateHandler.swift
//  vpn_plugin
//
//  Created by Aleksey Shadrov on 11.11.2024.
//

import Foundation
import Flutter

class VPNStateHandler: FlutterStreamHandler {
    static var _sink: FlutterEventSink?

    static func updateState(_ newState: Int, errorMessage: String? = nil) {
        guard let sink = _sink else {
            return
        }

        if let errorMsg = errorMessage {
            sink(FlutterError(code: "\(newState)",
                              message: errorMsg,
                              details: nil))
            return
        }

        sink(newState)
    }

    func onListen(withArguments _: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        VPNStateHandler._sink = events
        return nil
    }

    func onCancel(withArguments _: Any?) -> FlutterError? {
        VPNStateHandler._sink = nil
        return nil
    }
}
