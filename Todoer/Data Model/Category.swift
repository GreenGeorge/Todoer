//
//  Category.swift
//  Todoer
//
//  Created by George Ananda on 01/12/18.
//  Copyright © 2018 George Ananda. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
