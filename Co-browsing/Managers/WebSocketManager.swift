//
//  WebSocketManager.swift
//  Co-browsing
//
//  Created by Артем Бурдейный on 19/09/2019.
//  Copyright © 2019 Артем Бурдейный. All rights reserved.
//

import Foundation
import SwiftWebSocket

protocol WebSocketManagerDelegate: UIViewController {
    func recieveSocketMessage(message: Any)
}

class WebSocketManager {
    static let shared = WebSocketManager()
    
    var sessionId: String?
    
    var baseURL: String {
        guard let sessionId = sessionId else { return "" }
        return "ws://\(Constants.serverPath)/client?id=\(sessionId)"
    }
    
    var webSocket: WebSocket?
    
    var listeners = [WebSocketManagerDelegate]()
    
    enum CommandType: String {
        case terminate
        case error
        case ok
        case point
        case pointOff
        case click
        case text
        case clear
    }
    
    func createSocket() {
        guard baseURL.count > 0 else { return }
        
        webSocket = WebSocket(baseURL)
        webSocket?.event.open = { [weak self] in
            print("webSocket opened")
            guard let image = ScreenShotManager.shared.takeScreenShot(), let data = image.pngData() else { return }
            self?.webSocket?.send(data)
        }
        webSocket?.event.close = { code, reason, clean in
            print("webSocket closed")
        }
        webSocket?.event.error = { error in
            print("error \(error)")
        }
        webSocket?.event.message = { [weak self] message in
            print(message)
            guard let self = self else { return }
            guard let commandMessage = message as? [CommandType : Any] else { return }
            self.listeners.forEach({ (listener) in
                listener.recieveSocketMessage(message: commandMessage)
            })
            print("print \(message)")
        }
    }
}
