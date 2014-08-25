//
//  HayoManager.swift
//  HAYO
//
//  Created by mono on 8/25/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

func hayoString(id: String) -> String {
    return NSLocalizedString(id, tableName: "Hayo", comment: "")
}

struct HayoPreset {
    let id: String
    let messageIds: [String]
    init(id: String, messageIds: [String]) {
        self.id = id
        self.messageIds = messageIds
    }
    var preset: String { get { return hayoString(id) } }
    var messages: [HayoMessage] { get
    {
        return messageIds.map { key in return HayoMessage(id: key) } as [HayoMessage]
    }}
}

struct HayoMessage {
    let id: String
    var message: String { get { return hayoString(id) } }
    var replies: [String] { get { return replyIds.map { key in return hayoString(key) } as [String] }}
    var replyIds: [String] { get { return ["\(id)_R1", "\(id)_R2" ] }}
    init(id: String) {
        self.id = id
    }
}

class HayoManager {
    subscript(index: Int) -> HayoPreset! {
        get {
            switch index {
            case 0:
                return HayoPreset(id: "F935EDD6_P", messageIds: ["33BC25A3", "81CCDA80", "A3786AE0", "7810CD9C", "89DE4AAC"])
            default:
                assert(false)
                return nil
            }
        }
    }
    var count: Int { get { return 1 } }
}

class RemoteNotificationManager {
    
}