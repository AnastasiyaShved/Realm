//
//  ListsModel.swift
//  Realm
//
//  Created by Apple on 31.10.23.
//

import Foundation
import RealmSwift

//DTO - Data Transfer Object
class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}

extension Task {
    func mapToModel() -> TaskModel {
        return TaskModel(name: self.name, note: self.note, date: self.date, isComplete: self.isComplete)
    }
}

struct TaskModel {
    var name: String
    var note: String
    var date: Date
    var isComplete: Bool
}
