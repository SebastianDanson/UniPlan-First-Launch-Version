//
//  Notification.swift
//  UniPlan
//
//  Created by Student on 2020-09-07.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class Notification: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var task: Task?
    @objc dynamic var type = ""
    @objc dynamic var taskId = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
