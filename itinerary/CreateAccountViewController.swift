//
//  CreateAccountViewController.swift
//  itinerary
//
//  Created by Anthony on 5/1/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var newUsernameTextLab: UITextField!
    @IBOutlet weak var newEmailAddressTextLab: UITextField!
    @IBOutlet weak var newPasswordTextLab: UITextField!
    @IBAction func createBtn(sender: AnyObject) {
        let username = newUsernameTextLab.text
        let email = newEmailAddressTextLab.text
        let password = newPasswordTextLab.text
        
        if username != "" && email != "" && password != "" {
            
            // Set Email and Password for the New User.
            
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
                //如果有Error
                if error != nil {
                    print(error)
                    // There was a problem.
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                    
                }
                    //如果冇Error
                else {
                    
                    // Create and Login the New User with authUser
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: {
                        err, authData in
                        let userID = DataService.dataService.generateUserID()
                        let user = ["provider": authData.provider!, "email": email!, "username": username!, "id": userID]
                        
                        // Seal the deal in DataService.swift.
                        DataService.dataService.createNewAccount(authData.uid, user: user)
                    })
                    
                    // Store the uid for future access - handy!
                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    
                    // Enter the app.
                    self.performSegueWithIdentifier("NewUserLoggedIn", sender: nil)
                }
            })
            
        } else {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and a username.")
        }
    }
    @IBAction func cancelBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signupErrorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: title, style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
