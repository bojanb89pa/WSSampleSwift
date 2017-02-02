//
//  InternetConnectionManager.swift
//  WSSample
//
//  Created by Bojan Bogojevic on 1/30/17.
//  Copyright © 2017 Gecko Solutions. All rights reserved.
//

import UIKit
import ReachabilitySwift

class InternetConnectionManager: NSObject {
    
    static let shared = InternetConnectionManager()
    
    var reachability : Reachability = Reachability()!
    
    var isObserved = false
    
    func observeInternetConnection () {
        
        if(!isObserved) {
            reachability.whenReachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                
                DispatchQueue.main.async {
                    if reachability.isReachableViaWiFi {
                        print("Reachable via WiFi")
                    } else {
                        print("Reachable via Cellular")
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_INTERNET_CONNECTION_AVAILABLE), object: nil)
                }
            }
            reachability.whenUnreachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                DispatchQueue.main.async {
                    print("Not reachable")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_INTERNET_CONNECTION_NOT_AVAILABLE), object: nil)
                }
            }
            
            do {
                try reachability.startNotifier()
                isObserved = true
            } catch {
                print("Unable to start notifier")
            }
        }
    }
    
    func isThereInternetConnection() -> Bool {
        let remoteHostStatus = reachability.currentReachabilityStatus
        return remoteHostStatus != .notReachable
    }
    
}
