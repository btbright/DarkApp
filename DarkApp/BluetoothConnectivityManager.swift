//
//  BluetoothConnectivityManager.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/16/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol UserConnectivityManagerDelegate
{
    func receievedData(BluetoothData)
    func userAdded(User)
    func userUpdated(User)
    func userRemoved(User)
}

//encapulates app connection logic - keep implementation details out
//i.e. creates users and handles user state/events
class UserConnectivityManager : MultipeerManagerDelegate
{
    var delegate: UserConnectivityManagerDelegate?
    let multipeerManager: MultipeerManager? = nil
    var availableUsers = [BluetoothManagerUser]()
    
    init(initedMultipeerManager: MultipeerManager){
        multipeerManager = initedMultipeerManager
    }
    
    func lostPeer(peerID: MCPeerID) {
        for (index, user) in enumerate(availableUsers){
            if user.peerID == peerID {
                delegate?.userRemoved(user)
                availableUsers.removeAtIndex(index)
                break
            }
        }
    }
    
    func invitationWasReceived(fromPeer: String) {
        //
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        //
    }
    
    func foundPeer(peerID : MCPeerID) {
        requestUserDataFromUser(peerID)
    }
    
    private func requestUserDataFromUser(peerID: MCPeerID)
    {
        UserBasicInfoRequest(toPeer: peerID).makeRequest(multipeerManager!)
    }
    
    func receivedData(peerID: MCPeerID, receivedData: Dictionary<String, Dictionary<String, String>>?)
    {
        if let requestName = receivedData?["requestInfo"]?["name"]?
        {
            switch(requestName)
            {
            case BluetoothRequestNames.User.BasicInfo:
                recievedUserBasicInfo(UserBasicInfoData(peerID: peerID, data: receivedData!["requestInfo"]!))
            default:
                return
            }
        }
    }
    
    //update or add user
    private func recievedUserBasicInfo(userData: UserBasicInfoData)
    {
        var isNewUser = false
        var user = getAvailableUser(userData.userId)
        //if user doesn't exist
        if user == nil
        {
            isNewUser = true
            user = BluetoothManagerUser()
        }
        user!.peerID = userData.peerID
        user!.userId = userData.userId
        user!.firstName = userData.firstName
        user!.lastName = userData.lastName
        if (isNewUser){
            availableUsers.append(user!)
            delegate?.userAdded(user!)
        } else {
            delegate?.userUpdated(user!)
        }
    }
    
    private func getAvailableUser(userId: String) -> BluetoothManagerUser?
    {
        return availableUsers.filter { (user) -> Bool in
            return user.userId == userId
        }.first
    }
    private func getAvailableUser(peerId: MCPeerID) -> BluetoothManagerUser?
    {
        return availableUsers.filter { (user) -> Bool in
            return user.peerID == peerId
        }.first
    }
}

struct BluetoothRequestNames {
    struct User {
        static let BasicInfo = "User:BasicInfo"
    }
}

class BluetoothData
{
    let isSuccess = false
    var peerID: MCPeerID
    init(peerID : MCPeerID)
    {
        self.peerID = peerID
    }
}

class BluetoothDataRequest
{
    var requestName = ""
    var requestData = Dictionary<String, String>()
    var peerID: MCPeerID? = nil
    func makeRequest(manager: MultipeerManager)
    {
        var requestPackage = ["requestInfo": ["name":requestName], "requestData" : requestData]
        manager.sendData(dictionaryWithData: requestPackage, toPeer: peerID)
    }
}

class UserBasicInfoData : BluetoothData
{
    let firstName: String = ""
    let lastName: String = ""
    let userId: String = ""
    
    init(peerID : MCPeerID, data: Dictionary<String,String>)
    {
        super.init(peerID: peerID)
        firstName = data["firstName"]!
        lastName = data["lastName"]!
        userId = data["userId"]!
    }
}

class UserBasicInfoRequest : BluetoothDataRequest {
    init(toPeer: MCPeerID){
        super.init()
        self.peerID = toPeer
        requestName = BluetoothRequestNames.User.BasicInfo
   }
}

class BluetoothManagerUser : User {
    var peerID: MCPeerID? = nil
}