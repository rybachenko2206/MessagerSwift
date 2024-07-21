//
//  Date.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import Foundation

extension Date {
    
    var isToday: Bool { Calendar.current.isDateInToday(self) }
    
    var isYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    
    func displayDateString1() -> String? {
        if isToday {
            return MSDateFormatter.shared.string(from: self, format: .time)
        } else if isYesterday {
            return "Yesterday"
        } else {
            return MSDateFormatter.shared.string(from: self, format: .fullDate)
        }
    }
}
