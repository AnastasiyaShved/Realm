//
//  TastsListModel.swift
//  Realm
//
//  Created by Apple on 31.10.23.
//

import Foundation
import RealmSwift

class TasksList: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks = List<Task>()
}

