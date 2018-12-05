//
//  Item.swift
//  Todoer
//
//  Created by George Ananda on 01/12/18.
//  Copyright © 2018 George Ananda. All rights reserved.
//

import Foundation
import RealmSwift

//protocol Item {
//    var title: String { get set }
//    var done: Bool { get set }
//    var dateCreated: Date? { get set }
//}

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
