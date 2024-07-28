//
//  CitiesModel.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 28.01.2024.
//

import Foundation
import ObjectMapper

class CitiesModel : NSObject,NSCoding,Mappable  {
    var name : String?
    var id : Int?
    var latitude: String?
    var longitude: String?
    var population: Int?
    var region: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        name <- map["name"]
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        population <- map["population"]
        region <- map["region"]
        
       
  
    }

    required init(coder aDecoder: NSCoder){
        super.init()
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        population = aDecoder.decodeObject(forKey: "population") as? Int
        region = aDecoder.decodeObject(forKey: "region") as? String
       
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(population, forKey: "population")
        aCoder.encode(region, forKey: "region")
       
    }
    
    static var _appCities: [CitiesModel]!
    static var appCities: [CitiesModel]? {
        get {
            if (_appCities != nil) {
                return _appCities
            } else {
                let defaults = UserDefaults.standard
                if let unarchivedObject = defaults.object(forKey: "appCities") as? NSData {
                    _appCities = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [CitiesModel]
                    return _appCities
                }
                return nil
            }
        }
        
        set {
            _appCities = newValue
            let defaults = UserDefaults.standard
            
            if let countries = newValue {
                let archivedObject = NSKeyedArchiver.archivedData(withRootObject: countries)
                defaults.set(archivedObject, forKey: "appCities")
            } else {
                defaults.removeObject(forKey: "appCities")
            }
        }
    }
   
    
    
    
  
    
    
   
}
