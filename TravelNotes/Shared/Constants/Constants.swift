//
//  Constants.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 25.12.2023.
//

import Foundation
import UIKit

class Constants: NSObject {
    static let TurkeyID: Int = 224
    
    static var NavHeight: Float? {
        get{
            return UserDefaults.standard.float(forKey: "NavHeight")
        }
        
        set{
            UserDefaults.standard.set(newValue, forKey: "NavHeight")
        }
        
    }

}

var googleClientID = "" 
