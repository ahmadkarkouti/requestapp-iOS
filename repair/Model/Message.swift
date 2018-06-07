//
//  message.swift
//  repair
//
//  Created by Ahmad Karkouty on 6/5/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    @objc var fromId: String!
    @objc var text: String!
    @objc var toId: String!
    @objc var timestamp: NSNumber!
    @objc var imageUrl: String!
    @objc var imageWidth: NSNumber!
    @objc var imageHeight: NSNumber!
    
    func chatPartnerId() -> String? {
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        } else {
            return fromId
        }
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        toId = dictionary["toId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        
    }
    
}
