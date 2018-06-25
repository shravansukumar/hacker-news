//
//  Preferences.swift
//  hacker-news
//
//  Created by Shravan Sukumar on 24/06/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation

class Preferences {
    static var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: "userId")
        }
        
        set {
         UserDefaults.standard.setValue(newValue, forKey: "userId")
        }
    }
}
