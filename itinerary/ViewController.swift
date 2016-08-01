//
//  ViewController.swift
//  itinerary
//
//  Created by Anthony on 4/30/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {
    static let viewController = ViewController()
    
    @IBOutlet weak var emailLab: UITextField!
    @IBOutlet weak var passwordLab: UITextField!
    @IBAction func loginBtn(sender: AnyObject) {
        let email = emailLab.text
        let password = passwordLab.text
        
        if email != "" && password != ""{
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: {
                error, authData in
                if error != nil{
                    print(error)
                    self.loginErrorAlert("Oops!", message: "Check your username and password.")
                }else{
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    self.viewDidAppear(true)
                }
            })
        }else{
            loginErrorAlert("Oops", message: "Don't forget to enter your email and password.")
        }
    }
    @IBAction func register(sender: AnyObject) {
        let logout = FBSDKLoginManager()
        logout.logOut()
    }
    
    @IBAction func loginWithFB(sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: {(facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            }else{
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                DataService.dataService.BASE_REF.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: {error, authData in
                    if error != nil{
                        print("Login failed. \(error)")
                    }else{
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                        self.createAcIfNoExist()
                        self.viewDidAppear(true)
                    }})
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil{
            self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
        }
        
        if (FBSDKAccessToken.currentAccessToken() != nil) && NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil{
            self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
            createAcIfNoExist()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnUserData(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil){
                print("Error: \(error)")
            }else{
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }
    
    func loginErrorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func createAcIfNoExist(){
        DataService.dataService.BASE_REF.observeEventType(.Value, withBlock: {snapShot in
            for item in snapShot.children{
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                
                if let id = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String{
                    if dict[id] == nil{
                        let parameters = ["fields":"email, name"]
                        FBSDKGraphRequest(graphPath: "me",parameters: parameters).startWithCompletionHandler({(connection, result, requestError) -> Void in
                            if requestError != nil{
                                print(requestError)
                                return
                            }else{
                                let email = result["email"] as! String
                                let username = result["name"] as! String
                                let userID = DataService.dataService.generateUserID()
                                let FBUser = ["provider":"no provide", "email": email, "username": username, "id":userID]
                                DataService.dataService.createNewAccount(id, user: FBUser)
                            }
                            
                        })
                        
                    }
                }
            }
        })
    }
}

