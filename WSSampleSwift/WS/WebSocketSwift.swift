//
//  WebSocketSwift.swift
//  WSSample
//
//  Created by Bojan Bogojevic on 1/11/17.
//  Copyright © 2017 Gecko Solutions. All rights reserved.
//

import UIKit
import SocketRocket
import ReachabilitySwift

protocol WebSocketDelegate {
    func messageReceived(_ message: String)
}

class WebSocketSwift: NSObject {
    
    let RECONNECT_TIME_MAX = 15
    
    var reconnectCounter = 0
    
    var webSocket : SRWebSocket?
    
    let channel : WSChannel
    
    var delegate: WebSocketDelegate?
    
    init(channel: WSChannel) {
        self.channel = channel
        InternetConnectionManager.shared.observeInternetConnection()
    }
    
    func connect() {
        NotificationCenter.default.addObserver(self, selector: #selector(internetAvailable), name: NSNotification.Name(rawValue: NOTIFICATION_INTERNET_CONNECTION_AVAILABLE), object: nil)
        open()
    }
    
    func open() {
        webSocket = SRWebSocket(url: URL(string: channel.chanelUrl))
        webSocket?.delegate = self
        self.channel.status = .opening
        webSocket?.open()
    }
    
    
    func close() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_INTERNET_CONNECTION_AVAILABLE), object: nil)
        if webSocket != nil {
            self.channel.status = .closing
            webSocket?.close()
        }
    }
    
    func sendMessage(message: String) {
        self.webSocket?.send(message)
    }
    
    
    // MARK: Notification center
    
    func internetAvailable() {
        if channel.status == .cancel {
            open()
        }
    }
    
}

// MARK: SRWebSocket Delegate

extension WebSocketSwift: SRWebSocketDelegate {
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!){
        debugPrint(message)
        delegate?.messageReceived(message as! String)
    }
    
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        channel.status = .open
        reconnectCounter = 1
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        
        if reconnectCounter == 1 {
            print("Reconnecting...")
        }
        channel.status = .cancel
        // reconnect in 1s, 2s, 3s... 15s
        let tryAgainIn = DispatchTime.now() + DispatchTimeInterval.seconds(reconnectCounter)
        DispatchQueue.main.asyncAfter(deadline: tryAgainIn) {
            if(self.reconnectCounter <= self.RECONNECT_TIME_MAX) {
                self.reconnectCounter += 1
                self.webSocket?.close()
                self.open()
            }
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        channel.status = .closed
        print("WS (\(channel.channelId)) is closed!")
    }
}
