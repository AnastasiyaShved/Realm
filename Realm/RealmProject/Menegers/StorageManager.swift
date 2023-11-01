//
//  StorageManager.swift
//  Realm
//
//  Created by Apple on 1.11.23.
//

import UIKit
import RealmSwift

let realm = try! Realm()


class StorageManager {
    // универсальный метод по сортировке данных
    static func getAllTasksLists() -> Results<TasksList> {
        realm.objects(TasksList.self).sorted(byKeyPath: "name")
    }
    // метод  по  удалению всего списка
    static func deleteAll() {
        do {
            try realm.write{
                realm.deleteAll()
            }
        } catch {
            print("deleteAll ERROR: \(error)")
        }
    }
    //метод по  добавлению нового списка
    static func saveTasksList(tasksList: TasksList) {
        do {
            try realm.write{
                realm.add(tasksList)
            }
        } catch {
            print("saveTasksList ERROR: \(error)")
        }
    }
    
    static func deleteList(tasksList: TasksList) {
        do {
            try realm.write{
                realm.delete(tasksList)
            }
        } catch {
            print("deleteList ERROR: \(error)")
        }
    }
}


