//
//  UserModel.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 11.05.2024.
//

import Foundation
import ObjectMapper

class UserModel : NSObject, NSCoding, Mappable {
    var email : String?
    var first_name : String?
    var last_name : String?
    var profile_photo : String?
    var uid : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        email <- map["email"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        profile_photo <- map["profile_photo"]
        uid <- map["uid"]
    }

    required init(coder aDecoder: NSCoder){
        super.init()

        uid = aDecoder.decodeObject(forKey: "uid") as? String
        profile_photo = aDecoder.decodeObject(forKey: "profile_photo") as? String
        first_name = aDecoder.decodeObject(forKey: "first_name") as? String
        last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String

    }
    
    func encode(with aCoder: NSCoder) {

        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(profile_photo, forKey: "profile_photo")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(email, forKey: "email")
      
    }
    
   
    // Mark :- Authentication
    static var _currentUser: UserModel!
    static var currentUser: UserModel? {
        get {
            if (_currentUser != nil) {
                return _currentUser
            } else {
                let defaults = UserDefaults.standard
                if let unarchivedObject = defaults.object(forKey: "currentUser") as? NSData {
                    _currentUser = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? UserModel
                    return _currentUser
                }
                return nil
            }
        }
        set {
            _currentUser = newValue
            let defaults = UserDefaults.standard
            
            if let user = newValue {
                let archivedObject = NSKeyedArchiver.archivedData(withRootObject: user)
                defaults.set(archivedObject, forKey: "currentUser")
            } else {
                defaults.removeObject(forKey: "currentUser")
            }
        }
    }
    
    
    static var isLoggedIn: Bool {
        return (currentUser != nil && UserModel.UserToken != nil )
    }
    
    static var UserData: UserModel? {
        return UserModel.currentUser
    }
    
    
    static var UserToken: String? {
        get{
            return UserDefaults.standard.string(forKey: "user_token")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "user_token")
        }
    }
    
}


