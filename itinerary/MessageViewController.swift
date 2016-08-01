//
//  MessageViewController.swift
//  itinerary
//
//  Created by Anthony on 5/5/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var receiverID:String!
    var sendTo:String!
    var sendername:String!
    var sendTimeStr:String!
    var displayTimeStr:String!
    var newMsg:Dictionary<String,String> = [:]
    var displayMsg:[String] = []
    var displaytime:[String] = []
    var sentTime:[String] = []
    
    @IBOutlet weak var alarm: UISwitch!
    @IBOutlet weak var dataSelector: UIDatePicker!
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageTF: UITextField!
    @IBAction func sendbtn(sender: AnyObject) {
        formatdata()
        let msg:String!
        var alarmON:String = "false"
        var sent:String = "false"
        if messageTF.text != nil{
            msg = messageTF.text
            if self.alarm.on {
                alarmON = "true"
                sent = "true"
            }else{
                alarmON = "false"
            }
            print(self.sendTo)
            print(sendTimeStr)
            print(msg)
            print(displayTimeStr)
            print(alarmON)
            print(sent)
            print(sendername)
                newMsg = ["receiver":self.sendTo, "sendtime":sendTimeStr, "message":msg, "photo":"photo", "displaytime": displayTimeStr, "alarm": alarmON, "sent": sent, "sendername": sendername]
                sendToReciever()
                messageTF.text = ""
                alarm.setOn(false, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getSentMsg()
        alarm.setOn(false, animated: true)
        self.hideKeyboardWhenTappedAround()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func formatdata(){
        let setDate = dataSelector.date
        let nowDate = NSDate()
        self.sendTimeStr = TimeManage.timeManage.dateToString(nowDate)
        self.displayTimeStr = TimeManage.timeManage.dateToString(setDate)
    }
    
    func sendToReciever(){
        let sentID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        DataService.dataService.BASE_REF.childByAppendingPath("users").childByAppendingPath(receiverID).childByAppendingPath("MyMessage").childByAppendingPath(sentID).childByAutoId().setValue(newMsg)
        DataService.dataService.CURRENT_USER_REF.childByAppendingPath("sentmessage").childByAppendingPath(receiverID).childByAutoId().setValue(newMsg)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentTime.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath:  indexPath) as! MessageTableViewCell
        let numberOfMsg = displayMsg.count
        let displayIndex = numberOfMsg - indexPath.row - 1
        cell.sentMsg.text = displayMsg[displayIndex]
        cell.realTime.text = "Sent at \(sentTime[displayIndex])"
        cell.sentTiem.text = "Will arrive at \(displaytime[displayIndex])"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func getSentMsg(){
        DataService.dataService.CURRENT_USER_REF.childByAppendingPath("sentmessage/\(receiverID)").observeEventType(.Value, withBlock: {snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                self.displaytime = []
                self.sentTime = []
                self.displayMsg = []
                for snap in snapshots{
                    if let sentMsgDetail = snap.value as? Dictionary<String,String>{
                        self.displayMsg.append(sentMsgDetail["message"]!)
                        self.sentTime.append(sentMsgDetail["sendtime"]!)
                        self.displaytime.append(sentMsgDetail["displaytime"]!)
                        self.messageTableView.reloadData()
                    }
                }
            }
        })
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -210
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func disablesAutomaticKeyboardDismissal() -> Bool {
        return true
    }
}
