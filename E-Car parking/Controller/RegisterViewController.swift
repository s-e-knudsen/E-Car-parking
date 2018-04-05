//
//  RegisterViewController.swift
//  E-Car parking
//
//  Created by Søren Knudsen on 05/04/2018.
//  Copyright © 2018 Søren Knudsen. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD



class RegisterViewController: UIViewController {

    //MARK: - Definition of variables
    
    //Outlets deffenitions.
    
    
    @IBOutlet weak var registerEmailTextFeld: UITextField!
    @IBOutlet weak var registerPasswordFeld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        
        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: registerEmailTextFeld.text!, password: registerPasswordFeld.text!) { (user, error) in
            if error != nil {
                print(error!)
                //Alert popup definition
                
                SVProgressHUD.dismiss()
                //Popup for wrong username or password.
                let alert = UIAlertController(title: "Please enter a valid username and passord", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                //Success
                print("Success - User created")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToApp", sender: self)
            }
        }
        
        
        
        
    }
    
 

}
