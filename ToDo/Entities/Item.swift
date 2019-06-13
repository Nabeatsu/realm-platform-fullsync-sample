//
//  Item.swift
//  ToDo
//
//  Created by tanabe.nobuyuki on 2019/06/11.
//  Copyright © 2019 tanabe.nobuyuki. All rights reserved.
//

import RealmSwift


class Item: Object {
    @objc dynamic var itemId: String = UUID().uuidString
    @objc dynamic var body: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var timestamp: Date = Date()
    
    override static func primaryKey() -> String? {
        return "itemId"
    }
}
