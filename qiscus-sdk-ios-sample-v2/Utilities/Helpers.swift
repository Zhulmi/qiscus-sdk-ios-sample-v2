//
//  Helpers.swift
//  qiscus-sdk-ios-sample-v2
//
//  Created by Rohmad Sasmito on 11/7/17.
//  Copyright © 2017 Qiscus Technology. All rights reserved.
//
import Foundation
import Alamofire

class Helper: NSObject {
    static var APP_ID: String {
        get {
            return "sampleapp-65ghcsaysse"
        }
    }
    
    static var headers : HTTPHeaders {
        get {
            return [
                "platform": "ios",
                "lang": self.getLocalization()
            ]
        }
    }
    static var URL_CONTACTS: String {
        get {
            return "https://dashboard-sample.herokuapp.com/rest/contacts"
        }
    }
    
    static func urlContacts(of page: Int, limit: Int = 10) -> String {
        return "https://dashboard-sample.herokuapp.com/rest/contacts?page=\(page)&limit=\(limit)"
    }
    
    static func getLocalization() -> String{
        let localization:String = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode)! as! String
        return localization
    }
}
