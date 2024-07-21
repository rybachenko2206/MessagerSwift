//
//  MSDateFormatter.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import Foundation

class MSDateFormatter {
    enum DateFormat: String {
        case time = "HH:mm"
        case fullDate = "dd/MM/yyyy"
        case iso = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    static let shared = MSDateFormatter()
    
    private let dateFormatter = DateFormatter()
    
    private lazy var isoDateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        formatter.formatOptions = [.withFractionalSeconds]
        return formatter
    }()
    
    private init() {
        dateFormatter.timeZone = .current
    }
    
    func date(from string: String?, format: DateFormat) -> Date? {
        guard let dateStr = string else { return nil }
        
        switch format {
        case .iso:
            return isoDateFormatter.date(from: dateStr)
        default:
            dateFormatter.dateFormat = format.rawValue
            return dateFormatter.date(from: dateStr)
        }
    }
    
    func string(from date: Date?, format: DateFormat) -> String? {
        guard let date = date else { return nil }
        
        switch format {
        case .iso:
            return isoDateFormatter.string(from: date)
        default:
            dateFormatter.dateFormat = format.rawValue
            return dateFormatter.string(from: date)
        }
    }
}
