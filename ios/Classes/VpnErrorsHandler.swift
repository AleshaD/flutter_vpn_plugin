//
//  VpnErrorsHandler.swift
//  vpn_plugin
//
//  Created by Aleksey Shadrov on 12.11.2024.
//

import Foundation
import Flutter

class VpnErrorsHandler: FlutterStreamHandler {
    static var _sink: FlutterEventSink?
    
    static func sendError(code: String, errorMsg: String? = nil) {
        guard let sink = _sink else {
            return
        }
        
        sink("\(code)_\(errorMsg ?? "")")
    }

    func onListen(withArguments _: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        VpnErrorsHandler._sink = events
        return nil
    }

    func onCancel(withArguments _: Any?) -> FlutterError? {
        VpnErrorsHandler._sink = nil
        return nil
    }
}
