//
//  LoginViewController.swift
//  E-Car parking
//
//  Created by Søren Knudsen on 05/04/2018.
//  Copyright © 2018 Søren Knudsen. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    
    //MARK: - Variables
    
    //Outlets definition
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfeald: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        //action defines here.
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfeald.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
                //Popup for wrong username or password.
                let alert = UIAlertController(title: "Wrong username or password enterd", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("Login success")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToApp", sender: self)
                
            }
            
        }
        
    }
    
  
}
