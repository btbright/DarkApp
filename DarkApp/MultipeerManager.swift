//
//  MultipeerManager.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/14/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import Foundation
import MultipeerConnectivity

@objc protocol MultipeerManagerDelegate {
    optional func foundPeer(peerID: MCPeerID)
    optional func lostPeer(peerID: MCPeerID)
    optional func invitationWasReceived(fromPeer: String)
    optional func connectedWithPeer(peerID: MCPeerID)
    optional func receivedData(peerID: MCPeerID, receivedData: Dictionary<String, Dictionary<String, String>>?)
}


class MultipeerManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var delegate: MultipeerManagerDelegate?
    var session: MCSession!
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession!)->Void)!
    
    let serviceName: String = "bif-darkapp"
    
    override init() {
        super.init()
        
        peer = MCPeerID(displayName: UIDevice.currentDevice().name)
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceName)
        browser.delegate = self
        browser.startBrowsingForPeers()
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: serviceName)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    
    // MARK: MCNearbyServiceBrowserDelegate method implementation
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        foundPeers.append(peerID)
        
        delegate?.foundPeer!(peerID)
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        for (index, aPeer) in enumerate(foundPeers){
            if aPeer == peerID {
                foundPeers.removeAtIndex(index)
                break
            }
        }
        
        delegate?.lostPeer!(peerID)
    }
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
    
    
    // MARK: MCNearbyServiceAdvertiserDelegate method implementation
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        self.invitationHandler = invitationHandler
        
        delegate?.invitationWasReceived!(peerID.displayName)
    }
    
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        println(error.localizedDescription)
    }
    
    
    // MARK: MCSessionDelegate method implementation
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch state{
        case MCSessionState.Connected:
            println("Connected to session: \(session)")
            delegate?.connectedWithPeer!(peerID)
            
        case MCSessionState.Connecting:
            println("Connecting to session: \(session)")
            
        default:
            println("Did not connect to session: \(session)")
        }
    }
    
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        let dictionary: [String: AnyObject] = ["data": data, "fromPeer": peerID]
        //NSNotificationCenter.defaultCenter().postNotificationName("receivedMPCDataNotification", object: dictionary)
        if let unarchivedData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Dictionary<String,Dictionary<String,String>>
        {
            delegate?.receivedData!(peerID, receivedData: unarchivedData)
        } else {
            delegate?.receivedData!(peerID, receivedData: nil)
        }
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) { }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) { }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) { }
    
    
    
    // MARK: Custom method implementation
    
    func sendData(dictionaryWithData dictionary: Dictionary<String, Dictionary<String,String>>, toPeer targetPeer: MCPeerID?) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
        
        var peersArray = []
        if (targetPeer != nil){
            peersArray = NSArray(object: targetPeer!)
        } else {
            peersArray = foundPeers
        }
        var error: NSError?
        
        if !session.sendData(dataToSend, toPeers: peersArray, withMode: MCSessionSendDataMode.Reliable, error: &error) {
            println(error?.localizedDescription)
            return false
        }
        
        return true
    }
    
}
