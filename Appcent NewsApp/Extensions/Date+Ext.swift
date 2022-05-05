//
//  Date+Ext.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 3.05.2022.
//

import Foundation

extension Date {
    
    func convertToMonthDayYearFormat() -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }
}
