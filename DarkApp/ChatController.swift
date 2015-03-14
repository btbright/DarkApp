//
//  ChatController.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/10/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import UIKit

class ChatController: UITableViewController, ChatViewCellDelegate {
    var cellIdentifier: String = "chatCell"
    
    var invitedUsers: [ChatUser] = []
    
    @IBOutlet weak var logoLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColors.BG
        navigationController?.navigationBar.tintColor = UIColors.DarkText
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 90
        var settings = UserSettings()
        if settings.hasBeenSet {
            var user = ChatUser(firstName: settings.firstName, lastName: settings.lastName, userId: nil)
            user.isUser = true
            invitedUsers.insert(user, atIndex: 0)
        }
        
        if let font = UIFont(name: "Futura-MediumItalic", size: 20) {
            logoLabel.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
    }
    
    private func reloadChat()
    {
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? ChatViewCell
        
        let row = indexPath.row
        let currentUser = invitedUsers[row]
        cell?.index = row
        cell?.nameLabel.text = currentUser.firstName
        cell?.chatTextView.scrollEnabled = true
        cell?.chatTextView.text = currentUser.fakeChatText
        cell?.chatTextView.scrollEnabled = false
        cell?.layoutMargins = UIEdgeInsetsZero
        cell?.preservesSuperviewLayoutMargins = false
        cell?.delegate = self
        cell?.isUser = currentUser.isUser
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedUsers.count
    }
    
    private func clearChatCell(chatCell: ChatViewCell){
        invitedUsers[chatCell.index].fakeChatText = ""
        //reloadChat()
        chatCell.chatTextView.text = ""
        chatCell.chatTextView.sizeToFit()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func handleClearSignal(sender: ChatViewCell) {
        clearChatCell(sender)
    }
    
    func handleUserTextChange(sender: ChatViewCell) {
        invitedUsers[sender.index].fakeChatText = sender.chatTextView.text
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func handleUserStoppedTyping(sender: ChatViewCell) {
        //stuff maybe
    }
    
    func handleUserTextFocus(sender: ChatViewCell) {
        //stuff maybe
    }
    
    func handleUserTextBlur(sender: ChatViewCell) {
        //stuff maybe
    }
    
    func handleChatTextExpired(sender: ChatViewCell) {
        clearChatCell(sender)
    }
}
