//
//  Post.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/26/22.
//

import Foundation
class Post{
    var id: String
    var postText : String
    var  uid: String
    var Author : String
    
    init(_ id: String, _ postText: String, _ author:String, _ uid: String)
    {
        self.id = id
        self.uid = uid
        self.Author = author
        self.postText = postText
    }
    
    
}
