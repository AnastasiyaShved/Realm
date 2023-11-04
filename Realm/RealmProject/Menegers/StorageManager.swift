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
                ///нужны вытащить все таски, тк последовательно удаляем таски и только после таскслист
                let tasks = tasksList.tasks
                realm.delete(tasks)
                realm.delete(tasksList)
            }
        } catch {
            print("deleteList ERROR: \(error)")
        }
    }
    // метод по изменению листа 
    static func editeList(tasksList: TasksList, newListName: String) {
        do {
            try realm.write{
                tasksList.name = newListName
            }
        } catch {
            print("editeList ERROR: \(error)")
        }
    }
    
    static func makeAllDone(tasksList: TasksList) {
        do {
            try realm.write{
                tasksList.tasks.setValue(true, forKey: "isComplete")
            }
        } catch {
            print("makeAllDone ERROR: \(error)")
        }
    }
}


