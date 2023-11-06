//
//  StorageManager.swift
//  Realm
//
//  Created by Apple on 1.11.23.
//

import UIKit
import RealmSwift

let config = Realm.Configuration(
    schemaVersion: 2)

let realm = try! Realm(configuration: config)

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
    
    static func saveTask(tasksList: TasksList, task: Task) {
        do {
            try realm.write{
                tasksList.tasks.append(task)
            }
        } catch {
            print("saveTask ERROR: \(error)")
        }
    }
    
    static func editTask(task: Task,
                         newName: String,
                         newNote: String) {
        do {
            try realm.write{
                task.name = newName
                task.note = newNote
                
            }
        } catch {
            print("editTask ERROR: \(error)")
        }
    }
    
}


