//
//  UserSettings.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/11/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import Foundation

class UserSettings
{
    let settingsKey = "userSettings"
    
    var firstName: String = "" {
        didSet {
            saveToDisk()
        }
    }
    var lastName: String = "" {
        didSet {
            saveToDisk()
        }
    }
    var hasBeenSet: Bool {
        get {
            return firstName != "" && lastName != ""
        }
    }
    
    init()
    {
        if let settings = getSettings() {
            firstName = settings["firstName"]!
            lastName = settings["lastName"]!
        }
    }
    
    private func saveToDisk(){
        var settings: [NSObject : AnyObject] = [
            "firstName" : firstName,
            "lastName" : lastName
        ]
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(settings, forKey: settingsKey)
    }
    
    private func getSettings() -> [String : String]?
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let settings = userDefaults.dictionaryForKey(settingsKey){
            return settings as? [String : String]
        } else {
            return nil
        }
    }
}