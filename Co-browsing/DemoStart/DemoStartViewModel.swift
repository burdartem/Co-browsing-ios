//
//  DemoStartViewModel.swift
//  Co-browsing
//
//  Created by Артем Бурдейный on 19/09/2019.
//  Copyright © 2019 Артем Бурдейный. All rights reserved.
//

import Foundation

protocol DemoStartViewModelDelegate {
    func changeSessionStatus(selected: Bool)
}

class DemoStartViewModel {
    
    var delegate: DemoStartViewModelDelegate?
    
    func didPressSessionButton(selected: Bool) {
        if !selected {
            ServerManager.shared.request(to: .createSession, requestType: .post, successed: { data in
                guard let data = data as? [String : Any] else { return }
                guard let id = data["id"] as? String else { return }
                WebSocketManager.shared.sessionId = id
                WebSocketManager.shared.createSocket()
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.changeSessionStatus(selected: true)
                }
            }) {  _  in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.changeSessionStatus(selected: false)
                }
            }
        } else if let sessionId = WebSocketManager.shared.sessionId {
            ServerManager.shared.request(to: .deleteSession, appendingPath: sessionId, requestType: .delete, successed: { _ in
                WebSocketManager.shared.sessionId = nil
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.changeSessionStatus(selected: false)
                }
            }) {  _ in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.changeSessionStatus(selected: false)
                }
            }
        }
    }
    
}
