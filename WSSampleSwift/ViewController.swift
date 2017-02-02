//
//  ViewController.swift
//  WSSampleSwift
//
//  Created by Bojan Bogojevic on 2/2/17.
//  Copyright © 2017 Gecko Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    let wsUrl = "ws://echo.websocket.org"
    var webSocket : WebSocketSwift?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webSocket = WebSocketSwift(channel: WSChannel(channelId: "0", chanelUrl: wsUrl))
        self.webSocket?.connect()
        self.webSocket?.delegate = self
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if self.webSocket?.channel.status == .open {
            self.webSocket?.sendMessage(message: "Echo message!!!")
        }
    }
    
}

extension ViewController : WebSocketDelegate {
    
    func messageReceived(_ message: String) {
        messageLabel.text = message
    }
}

