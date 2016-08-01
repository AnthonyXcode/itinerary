//
//  TimeManage.swift
//  itinerary
//
//  Created by Anthony on 5/6/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import Foundation
class TimeManage{
    static let timeManage = TimeManage()
    private let dateComponents = NSDateComponents()
    private let currentDate = NSDate()
    private let dateFormatter = NSDateFormatter()
    private func setFormatter(){
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    func isThedateEailerThanNow(str:String)->Bool{
        setFormatter()
        let theDate = stringToDate(str)
        if currentDate.earlierDate(theDate) == currentDate{
            return false
        }else{
            return true
        }
    }
    
    func isDateOneEalierThanDateTwo(str1:String,str2:String)->Bool{
        setFormatter()
        let date1 = stringToDate(str1)
        let date2 = stringToDate(str2)
        if date1.earlierDate(date2) == date1{
            return true
        }else{
            return false
        }
    }
    
    func dateToString(date:NSDate)->String{
        setFormatter()
        let str = dateFormatter.stringFromDate(date)
        return str
    }
    
    func stringToDate(Str:String)->NSDate{
        setFormatter()
        let date = dateFormatter.dateFromString(Str)!
        return date
    }
}