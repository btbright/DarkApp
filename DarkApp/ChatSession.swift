//
//  ChatSession.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/11/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import Foundation

class ChatSession : MultipeerManagerDelegate
{
    var invitedUsers: [ChatUser] = []
    var joinedUsers: [ChatUser] {
        get {
            return invitedUsers.filter { (user) -> Bool in
                return user.hasJoined
            }
        }
    }
    var chatInfo: [String: String] = [:] //userid : message
    init()
    {
        
    }
}