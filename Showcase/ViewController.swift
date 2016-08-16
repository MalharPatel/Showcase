//
//  ViewController.swift
//  Showcase
//
//  Created by Malhar Patel on 8/12/16.
//  Copyright © 2016 Malhar Patel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions( [ "email" ], fromViewController: self ) { ( facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            if facebookError != nil {
                print ("Facebook Login Failed. Error \(facebookError)")
            } else {
                let accessToken = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString);
                
                FIRAuth.auth()?.signInWithCredential(accessToken, completion: { (authData: FIRUser?, error: NSError?) in
                    if error != nil {
                        print("Login Failed. \(error.debugDescription)")
                    } else {
                        print("Log in Successful! \(authData?.providerID)")
                        
                        let user = ["provider": accessToken.provider]
                        DataService.ds.createFirebaseUser(authData!.uid, user: user)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData?.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        
                    }
                })
            }
        }
    }
    
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailField.text where emailField != "", let pwd = passField.text where pwd != "" {
            FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user: FIRUser?, error: NSError?) in
                if error != nil {
                    print("Account has been found")
                    print(error.debugDescription)
                    self.login()
                } else {
                    print("User has been created")
                    self.login()
                }
            })
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")
        }
    }
    
    func login() {
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passField.text!, completion: { (authData: FIRUser?, error: NSError?) in
            if error != nil {
                print("Invalid Password")
                self.showErrorAlert("Invalid Password", msg: "Please enter a valid password")
            } else {
                print("Logged in succesfully")
                let user: [String: String] = ["provider": "password"]
                DataService.ds.createFirebaseUser(authData!.uid, user: user)
                NSUserDefaults.standardUserDefaults().setValue(authData?.uid, forKey: KEY_UID)
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
            }
        })
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }


}

