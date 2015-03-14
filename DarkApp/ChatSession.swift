//
//  ChatSession.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/11/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import Foundation

class ChatSession
{
    var invitedUsers: [ChatUser] = []
    var joinedUsers: [ChatUser] {
        get {
            return invitedUsers.filter { (user) -> Bool in
                return user.hasJoined
            }
        }
    }
    var chatInfo: [String: String] = [:]
    init()
    {
        chatInfo["test"] = "this is a test"
    }
}

/*
//view/controller
- handles keyboard input for user
- adds/removes users as the enter/leave chat
- updates users' chat label with their inputs

//model
outputs
- userlist, chat info

inputs
- connection events, chat events


*/