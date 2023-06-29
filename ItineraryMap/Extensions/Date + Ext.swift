//
//  Date + Ext.swift
//  ItineraryMap
//
//  Created by Elise on 2/14/23.
//

import Foundation

extension Date {
    
    func asFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}
