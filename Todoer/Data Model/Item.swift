//
//  Item.swift
//  Todoer
//
//  Created by George Ananda on 01/12/18.
//  Copyright © 2018 George Ananda. All rights reserved.
//

import Foundation
import RealmSwift

class RealmItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
