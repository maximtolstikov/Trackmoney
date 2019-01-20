//
//  DateSetter.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 20/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation

struct DateSetter {
    
    func date(stringDate: String?) -> NSDate {

        if let stringDate = stringDate,
            let date = DateFormat().dateFormatter.date(from: stringDate ) {
            return date as NSDate
        } else {
            return NSDate(timeIntervalSinceNow: 0.0)
        }
    }
    
}
