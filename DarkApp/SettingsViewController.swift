//
//  SettingsViewController.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/11/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: SettingsTextField!
    @IBOutlet weak var lastNameTextField: SettingsTextField!
    
    @IBAction func saveSettingsClick(sender: UIBarButtonItem) {
        var settings = UserSettings()
        settings.firstName = firstNameTextField.text
        settings.lastName = lastNameTextField.text
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColors.DarkText
        var settings = UserSettings()
        firstNameTextField.text = settings.firstName
        lastNameTextField.text = settings.lastName
    }
}
