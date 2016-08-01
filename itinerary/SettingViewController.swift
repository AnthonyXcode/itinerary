//
//  SettingViewController.swift
//  itinerary
//
//  Created by Anthony on 5/3/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var IDLab: UILabel!
    @IBAction func setIDbtn(sender: AnyObject) {
    }
    @IBAction func logOutbtn(sender: AnyObject) {
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil{
            DataService.dataService.CURRENT_USER_REF.unauth()
        }
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        let fblogout = FBSDKLoginManager()
        fblogout.logOut()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updataInterface()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updataInterface(){
        DataService.dataService.CURRENT_USER_REF.childByAppendingPath("MyID").observeEventType(.Value, withBlock: {snap in
            print(snap)
            if let userdata = snap.value as? Dictionary<String,String>{
                print(userdata)
                let Myname = userdata["username"]
                let MyID = userdata["id"]
                self.nameLab.text = Myname
                self.IDLab.text = MyID
                self.userImage.image = UIImage(named: "alien")
            }
        })
    }
    
}
