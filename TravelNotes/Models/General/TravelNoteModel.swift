//
//  TravelNoteModel.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 31.12.2023.
//

import Foundation
import ObjectMapper

struct TravelNoteModel : Mappable {
    var id : String?
    var photoUrl : String?
    var title : String?
    var note : String?
    var user: UserModel?
    var location: CitiesModel?
    var date: String?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        photoUrl <- map["photoUrl"]
        title <- map["title"]
        note <- map["note"]
        user <- map["user"]
        location <- map["location"]
        date <- map["date"]
    }

}

