//
//  ItinTableViewController.swift
//  itinerary
//
//  Created by Anthony on 5/6/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import UIKit

class ItinTableViewController: UITableViewController {
    
    var dateArray:[String] = []
    var senderArray:[String] = []
    var alartArray:[String] = []
    var msgArray:[String] = []
    var imageArray:[String] = []
    var sentArray:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        updateMsg()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        var numberOfRows = 0
        print(sentArray)
        for issent in sentArray{
            if issent == "true"{
                numberOfRows = numberOfRows + 1
            }
        }
        // #warning Incomplete implementation, return the number of rows
        print(numberOfRows)
        return numberOfRows
    }
    
    func updateMsg(){
        DataService.dataService.CURRENT_USER_REF.childByAppendingPath("MyMessage").observeEventType(.Value, withBlock: {snapshot in
            var sentTimeArr:[String] = []
            var senderArr:[String] = []
            var messageArr:[String] = []
            var alarmArr:[String] = []
            var imageArr:[String] = []
            var sentArr:[String] = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots{
                    print(snap)
                    if let MyMsg = snap.value as? Dictionary<String,Dictionary<String,String>>{
                        for (msgID, msg) in MyMsg{
                            if let theDate = msg["displaytime"], let name = msg["sendername"], let alarm = msg["alarm"], let img = msg["photo"], let message = msg["message"], let sent = msg["sent"]{
                                print(theDate)
                                sentTimeArr.append(theDate)
                                senderArr.append(name)
                                messageArr.append(message)
                                alarmArr.append(alarm)
                                imageArr.append(img)
                                sentArr.append(sent)
                                if TimeManage.timeManage.isThedateEailerThanNow(theDate){
                                    DataService.dataService.CURRENT_USER_REF.childByAppendingPath("MyMessage/\(snap.key as String)/\(msgID)/sent").setValue("true")
                                }
                                }
                            }
                        }
                    }
                }
            self.ascendingOrder(sentTimeArr, sender: senderArr, message: messageArr, alarm: alarmArr, image: imageArr, sent: sentArr)
            self.tableView.reloadData()
            }
        )
    }
    
    func ascendingOrder(sendTime:[String], sender:[String], message:[String], alarm:[String], image:[String], sent:[String]){
        dateArray = []
        senderArray = []
        alartArray = []
        msgArray = []
        imageArray = []
        sentArray = []
        var k = 0
        for dateTime in sendTime{
            var i = 0
            print(msgArray)
            if dateArray.isEmpty{
                dateArray.append(dateTime)
                senderArray.append(sender[k])
                alartArray.append(alarm[k])
                msgArray.append(message[k])
                imageArray.append(alarm[k])
                sentArray.append(sent[k])
                print(msgArray)
            }else{
                for data in dateArray{
                    if TimeManage.timeManage.isDateOneEalierThanDateTwo(dateTime, str2: data){
                        i = i + 1
                    }
                }
                dateArray.insert(dateTime, atIndex: i)
                senderArray.insert(sender[k], atIndex: i)
                alartArray.insert(alarm[k], atIndex: i)
                msgArray.insert(message[k], atIndex: i)
                imageArray.insert(image[k], atIndex: i)
                sentArray.insert(sent[k], atIndex: i)
                print(message[k])
                print(msgArray)
            }
            k = k + 1
        }
        print(dateArray)
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("receivedMsg", forIndexPath: indexPath) as! ItinTableViewCell
        cell.senderNameLab.text = senderArray[indexPath.row]
        print(sentArray[indexPath.row])
        if sentArray[indexPath.row] == "true"{
            cell.senderNameLab.text = senderArray[indexPath.row]
            print(cell.senderNameLab.text)
            if alartArray[indexPath.row] == "true"{
                cell.msgLab.text = "Alarm"
                cell.alermTimeLab.text = dateArray[indexPath.row]
            }else{
                cell.alermTimeLab.font = cell.alermTimeLab.font.fontWithSize(10)
                cell.setAlarmSwh.hidden = true
                cell.alermTimeLab.text = dateArray[indexPath.row]
                cell.msgLab.text = msgArray[indexPath.row]
            }
        }

        return cell
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
