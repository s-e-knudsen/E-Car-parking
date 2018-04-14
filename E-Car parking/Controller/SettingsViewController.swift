//
//  SettingsViewController.swift
//  E-Car parking
//
//  Created by Søren Knudsen on 07/04/2018.
//  Copyright © 2018 Søren Knudsen. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    //let vc = ViewController()
    @IBOutlet weak var settingsSwitch: UISwitch!
    @IBOutlet weak var userEmailAdress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //settingsSwitch.isOn = vc.userDataSwitchEnabled
        self.settingsSwitch.addTarget(self, action: #selector(switchstatedchenged), for: UIControlEvents.valueChanged)
        userEmailAdress.text = "Login name:    " + (Auth.auth().currentUser?.email)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchButtonActivated(_ sender: UISwitch) {
   
//        if settingsSwitch.isOn {
//            print("switch is on")
//            settingsSwitch.setOn(true, animated: true)
//            //vc.userDataSwitchEnabled = true
//            //print(vc.userDataSwitchEnabled)
//
//        } else {
//            print("switch is off")
//            settingsSwitch.setOn(false, animated: true)
//            //vc.userDataSwitchEnabled = false
//            //print(vc.userDataSwitchEnabled)
//        }
//
//        //vc.userDefaults.set(vc.userDataSwitchEnabled, forKey: "UserSwitch")
        
    }
    @IBAction func logoutPresed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error login out")
            return
        }
        //vc.userDefaults.set(vc.userDataSwitchEnabled, forKey: "UserSwitch")
    }
    
    //Load settings from User defaults. 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard.bool(forKey: "UserSwitch")
        self.settingsSwitch.setOn(userDefaults, animated: false)
    }
    
    @objc func switchstatedchenged(switchstate: UISwitch) {
        let userDefaults = UserDefaults.standard
        
        //Saving the UserDefaults state
        userDefaults.set(switchstate.isOn, forKey: "UserSwitch")
        print("The state is:")
        print(switchstate.isOn)

    }

}
