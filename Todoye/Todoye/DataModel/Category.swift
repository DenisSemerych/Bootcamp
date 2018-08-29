//
//  Category.swift
//  Todoye
//
//  Created by Denis Semerych on 07.06.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var hexColor = ""
    
    let items = List<Item>()
}
