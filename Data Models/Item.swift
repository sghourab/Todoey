//
//  Item.swift
//  Todoey
//
//  Created by Summer Crow on 2019-02-26.
//  Copyright © 2019 ghourab. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var done: Bool = false
    @objc dynamic var itemCellBackgroundHex: String?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
