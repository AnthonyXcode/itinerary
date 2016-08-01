//
//  DataService.swift
//  itinerary
//
//  Created by Anthony on 5/1/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import Foundation

class  DataService{
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var email:String = "a"
    private var userName:String = "b"
    private var userID:String = "c"
    
    
    var BASE_REF:Firebase{
        return _BASE_REF
    }
    
    var USER_REF:Firebase{
        return _USER_REF
    }
    
    var CURRENT_USER_REF:Firebase{
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = _USER_REF.childByAppendingPath(userID)
        return currentUser
    }
    
    func GET_USER_DATA () -> Dictionary<String, String>{
        //var userData:Dictionary<String,String> = [:]
        if ifLoginWithFB{
            getDataByFB()
            print(USER_INFO)
            return USER_INFO
        }else{
            return USER_INFO
        }
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>){
        USER_REF.childByAppendingPath(uid).childByAppendingPath("MyID").setValue(user)
    }
    
    func addFriend(uid:String, friend:Dictionary<String,String>){
        let currentUID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        print(currentUID)
        USER_REF.childByAppendingPath(currentUID)?.childByAppendingPath("Myfriends").childByAppendingPath(uid).setValue(friend)
    }
    
    var ifLoginWithFB:Bool{
        var loginwithfb = false
        if FBSDKAccessToken.currentAccessToken() != nil{
            loginwithfb = true
            return loginwithfb
        }else{
            return loginwithfb
        }
    }
    
    func getDataByFB(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                self.userName = result.valueForKey("name") as! String
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                self.email = result.valueForKey("email") as! String
                print("User Email is: \(userEmail)")
                self.USER_INFO
                print(self.USER_INFO)
            }
        })
    }
    
    var USER_INFO:Dictionary<String,String>{
        let info:Dictionary = ["id":userID, "email":email, "name":userName]
        return info
    }
    
    func generateUserID() -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<5) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}






