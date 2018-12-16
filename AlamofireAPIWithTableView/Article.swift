//
//  Article.swift
//  AlamofireAPIWithTableView
//
//  Created by Vattanac on 12/15/18.
//  Copyright © 2018 vattanac. All rights reserved.
//

import Foundation
import ObjectMapper

class Article :Mappable{
    
    var title:String!
    var imageUrl:String!
    var description:String!
    //var author:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["TITLE"]
        imageUrl  <- map["IMAGE"]
        description <- map["DESCRIPTION"]
    }
    
    
}
