//
//  DateSetter.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 20/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation

struct DateSetter {
    
    let dateFormat = DateFormat()
    
    func date(stringDate: String?) -> NSDate {

        if let stringDate = stringDate,
            let date = dateFormat.dateFormatter.date(from: stringDate ) {
            return date as NSDate
        } else {
            return NSDate(timeIntervalSinceNow: 0.0)
        }
    }
    
    func date() -> String {
        let currentDate = NSDate(timeIntervalSinceNow: 0.0) as Date
        dateFormat.dateFormatter.dateStyle = .short
        dateFormat.dateFormatter.timeStyle = .short
        let date = dateFormat.dateFormatter.string(from: currentDate)
        return date.cleanWhitespace()
    }
    
}
