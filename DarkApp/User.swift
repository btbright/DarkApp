//
//  User.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/9/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import Foundation

class User
{
    var isUser: Bool = false
    var firstName: String = ""
    var lastName: String = ""
    var userId: String = ""
    
    init(){
        
    }
    
    init(firstName firstNameInit: String, lastName lastNameInit: String, userId userIdInit: String?){
        if let userIdParsed = userIdInit {
            userId = userIdParsed
        } else {
            userId = NSUUID().UUIDString
        }
        firstName = firstNameInit
        lastName = lastNameInit
    }
}

class ChatUser : User
{
    var isSelected: Bool = false
    var hasJoined: Bool = false
    var fakeChatText: String = ""
}