//
//  Notes.swift
//  UniPlan
//
//  Created by Student on 2020-07-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class Note: Object {
    
    @objc dynamic var id = UUID().uuidString //Unique id
    @objc dynamic var title = ""
    @objc dynamic var notes = ""
    @objc dynamic var course = ""
    @objc dynamic var dateCreated = Date()
    var color = List<Double>() //Stores RGB values of color
    
    required init() {
        color.append(objectsIn: [0, 0, 0])
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
