//
//  Channel.swift
//  WSSample
//
//  Created by Bojan Bogojevic on 2/2/17.
//  Copyright © 2017 Gecko Solutions. All rights reserved.
//

import UIKit

class WSChannel {
    
    let channelId: String
    let chanelUrl: String
    var status: Status
    
    public enum Status{
        case initial
        case opening
        case open
        case closing
        case closed
        case cancel
    }
    
    public init(channelId: String, chanelUrl: String) {
        self.channelId = channelId
        self.chanelUrl = chanelUrl
        self.status = .initial
    }
}
