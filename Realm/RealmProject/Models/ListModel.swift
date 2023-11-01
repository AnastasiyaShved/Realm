//
//  ListsModel.swift
//  Realm
//
//  Created by Apple on 31.10.23.
//

import Foundation
import RealmSwift

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}
