//
//  ViewController.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/9/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import UIKit

class AvailableUsersController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //model
    var availableUsers: [ChatUser] = []{
        didSet {
            availableUsersChanged()
        }
    }
    var selectedUsers: [ChatUser] {
        get {
            return availableUsers.filter { (user) -> Bool in
                return user.isSelected
            }
        }
    }
    
    var cellIdentifier: String = "userCell"
    
    @IBOutlet weak var startChatButton: UIBarButtonItem!
    @IBOutlet weak var logoLabel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColors.BG
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 45
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if let font = UIFont(name: "Futura-MediumItalic", size: 20) {
            logoLabel.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        startChatButton.enabled = false
        startChatButton.tintColor = UIColor.clearColor()
        loadUsers()
    }
    
    override func viewWillAppear(animated: Bool) {
        for user in availableUsers {
            user.isSelected = false
        }
        availableUsersChanged()
    }
    
    private func loadUsers() {
        availableUsers = [
            ChatUser(firstName: "John", lastName: "Smith", userId: nil),
            ChatUser(firstName: "Ted", lastName: "Friendly", userId: nil),
            ChatUser(firstName: "Al", lastName: "Johnson", userId: nil)
        ]
        availableUsers[0].fakeChatText = "Testing this is a test. I wonder if it will wrap properly"
        availableUsers[2].fakeChatText = "another test"
    }
    
    //handlers
    private func availableUsersChanged(){
        tableView.reloadData()
        
        if selectedUsers.count == 0 {
            startChatButton.enabled = false
            startChatButton.tintColor = UIColor.clearColor()
        } else {
            startChatButton.tintColor = UIColors.Highlight
            startChatButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil
        { return }
        switch segue.identifier! {
            case "StartChat":
                if let viewController = segue.destinationViewController as? ChatController {
                    viewController.invitedUsers = selectedUsers
                }
            default:break
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? AvailableUserViewCell
        
        let row = indexPath.row
        let currentUser = availableUsers[row]
        cell?.userNameLabel.text = currentUser.firstName + " " + currentUser.lastName
        cell?.layoutMargins = UIEdgeInsetsZero
        cell?.preservesSuperviewLayoutMargins = false
        cell?.backgroundColor = UIColor.clearColor()
        
        if currentUser.isSelected {
            cell?.userNameLabel.textColor = UIColors.Highlight
            cell?.selectedIndicator.backgroundColor = UIColors.Highlight
            cell?.selected = true
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        } else {
            cell?.userNameLabel.textColor = UIColors.Text
            cell?.selectedIndicator.backgroundColor = UIColors.Indicator
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableUsers.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        availableUsers[indexPath.row].isSelected = true
        availableUsersChanged()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        availableUsers[indexPath.row].isSelected = false
        availableUsersChanged()
    }
}

