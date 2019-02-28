//
//  Category.swift
//  Todoey
//
//  Created by Summer Crow on 2019-02-26.
//  Copyright © 2019 ghourab. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
