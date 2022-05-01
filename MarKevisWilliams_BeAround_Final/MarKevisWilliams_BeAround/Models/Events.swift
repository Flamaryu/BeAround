//
//  Events.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/13/22.
//

import Foundation
class Event{
    var id: String
    var eventName: String
    var location: String
    var description: String
    var date: String
    var catergory: String
    var uid: String
    var attendingUID: [String]
    var post: [Post]
    
    init(id: String, eventName: String, location: String,description: String, date: String, catergory: String, uid: String, attendingUID: [String]  = [String](),  post: [Post] = [] ){
        self.id = id
        self.eventName = eventName
        self.location = location
        self.date = date
        self.description = description
        self.catergory = catergory
        self.uid = uid
        self.attendingUID = attendingUID
        self.post = post
    }
    
}
