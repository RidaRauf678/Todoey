//
//  Item.swift
//  Todoey
//
//  Created by Tianna Henry-Lewis on 2018-08-21.
//  Copyright © 2018 Tianna Henry-Lewis. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
