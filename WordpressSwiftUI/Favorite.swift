//
//  Favorite.swift
//  WordpressSwiftUI
//
//  Created by berk birkan on 6.07.2020.
//  Copyright © 2020 berk birkan. All rights reserved.
//

import Foundation
import RealmSwift
class Favorite: Object,Identifiable {
    
    var id = UUID()
    
  
    
    @objc dynamic var title = "Title"
    @objc dynamic var date = "01-06-2020"
    @objc dynamic var content = "Content"
    @objc dynamic var desc = "Desc"
    @objc dynamic var image = ""
    @objc dynamic var category = "General"
    @objc dynamic var comment = "52"
    @objc dynamic var link = ""
    @objc dynamic var postid = ""
    @objc dynamic var author_name = ""
    @objc dynamic var featuredmedia = ""
    
    override static func primaryKey() -> String? {
        return "content"
    }
    
}
