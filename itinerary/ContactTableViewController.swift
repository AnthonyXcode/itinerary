//
//  ContactTableViewController.swift
//  itinerary
//
//  Created by Anthony on 5/4/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    var friendName:[String]=[]
    var receiverID:[String]=[]
    var senderNmae:String!
    
    @IBAction func addContact(sender: AnyObject) {
        let alert = UIAlertController(title: "Add A Contact", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({(textField) -> Void in
            textField.placeholder = "Enter your Friend's ID"
        })
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("TEXT FIELD:\(textField.text)")
            self.findFriend(textField.text!)
        }))
        presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updataFriendlist()
        getSenderIndo()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendName.count
    }
    
    func findFriend(findID:String){
        DataService.dataService.USER_REF.observeEventType(.Value, withBlock: {
            snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots {
                    let friendkey = snap.key
                    print(snap.key)
                    if let checkAllMyID = snap.childSnapshotForPath("MyID").value as? Dictionary<String,String>{
                        let friendName = checkAllMyID["username"]
                        let friendEmail = checkAllMyID["email"]
                        let friendID = checkAllMyID["id"]
                        let userInfo = ["email":friendEmail!, "name":friendName!]
                        if let mykey = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String{
                            if mykey != friendkey{
                                if findID == friendID{
                                    DataService.dataService.addFriend(friendkey, friend: userInfo)
                                    self.updataFriendlist()
                                }
                            }
                        }
                    }
                }
            }})
    }
    
    func updataFriendlist(){
        if let myuid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String{
            let myfriendlist:Firebase = DataService.dataService.USER_REF.childByAppendingPath(myuid).childByAppendingPath("Myfriends")
            myfriendlist.observeEventType(.Value, withBlock: {
                snapshot in
                print(snapshot)
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                    self.friendName = []
                    self.receiverID = []
                    for snap in snapshots{
                        self.receiverID.append(snap.key as String)
                        if let frinedDetial = snap.value as? Dictionary<String,String>{
                            if let friendname = frinedDetial["name"]{
                                self.friendName.append(friendname)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            })
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactTableViewCell
        cell.contactNameLab.text = friendName[indexPath.item]
        cell.contactImage.image = UIImage(named: "aliennew")
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.height / 2
        cell.contactImage.clipsToBounds = true

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goSendMsg"{
            if let indexpath = self.tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! MessageViewController
                destinationController.receiverID = self.receiverID[indexpath.item]
                destinationController.sendTo = self.friendName[indexpath.item]
                destinationController.sendername = self.senderNmae
            }
        }
    }
    
    func getSenderIndo(){
        DataService.dataService.CURRENT_USER_REF.childByAppendingPath("MyID").observeEventType(.Value, withBlock: {snapshot in
            if let userInfo = snapshot.value as? Dictionary<String,String>{
                self.senderNmae = userInfo["username"]
            }})
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
