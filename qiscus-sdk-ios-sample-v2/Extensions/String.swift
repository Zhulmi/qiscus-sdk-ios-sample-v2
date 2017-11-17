//
//  String.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/15/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//

import Foundation

extension String {
    func timestampFormat(of time: String?) -> String {
        let dateFormat               = DateFormatter()
        dateFormat.dateFormat        = "d MMMM yyyy"
        dateFormat.timeZone          = TimeZone.autoupdatingCurrent
        
        if let date = dateFormat.date(from: self) {
            if date.today() {
                if let time = time {
                    return time
                }
                return "Today"
                
            } else {
                dateFormat.dateFormat = "dd/MM/yyyy"
                return dateFormat.string(from: date)
            }
            
        } else {
            return self
        }
    }
    
    var isValidEmail: Bool {
        get {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailMatch = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            return emailMatch.evaluate(with: self)
        }
    }
    
    static var timestampNow: String {
        get {
            let dateFormat          = DateFormatter()
            dateFormat.dateFormat   = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormat.timeZone     = TimeZone.autoupdatingCurrent
            
            return dateFormat.string(from: Date())
        }
    }
    
    func getRandomAvatar() -> String {
        if !(self.isValidEmail) { return "" }
        let emailStr = self.replacingOccurrences(of: "[\\@.]",
                                                 with: "-",
                                                 options: .regularExpression,
                                                 range: nil)
        return "https://robohash.org/\(emailStr)/bgset_bg1/3.14159?set=set4"
    }
}
