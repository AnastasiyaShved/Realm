//
//  TasksTVC.swift
//  Realm
//
//  Created by Apple on 31.10.23.
//

import UIKit
import Realm
import RealmSwift

enum TasksTVCFlow {
    case addingNewTask
    case edditingTask(task: Task)
}

struct TextAlertData {
    let titleForAlert = "Task value"
    let messageForAlert: String
    let doneButtinForAlert: String
    let canclTxt = "Cancel"
    
    let newTextFieldPlaceholder = "New task"
    let noteTextFieldPlaceholder = "Note"
    
    var taskName: String?
    var tasknato: String?

    
    init(tasksTVCFlow: TasksTVCFlow) {
        switch tasksTVCFlow {
        case .addingNewTask:
            messageForAlert = "Please insert new task value"
            doneButtinForAlert = "Save"
        case .edditingTask(task: let task):
            messageForAlert = "Please insert new task"
            doneButtinForAlert = "Update"
            taskName = task.name
            tasknato = task.note
        }
    }
}

class TasksTVC: UITableViewController {

    var index: Int?

    private var data: [[TaskModel]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemSelector))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonItemSelector))
    
        navigationItem.setRightBarButtonItems([add, edit], animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int { return data.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
        ///настраиваем названия секциий ( можно  сделать через более кастомно настройкиviewForFooterInSection)
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Not completed tasks" : "Completed tasks"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = data[indexPath.section][indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //перемечение ячеек
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            data[sourceIndexPath.section].move(fromOffsets: IndexSet(integer: sourceIndexPath.row), toOffset: destinationIndexPath.row)
        } else {
            guard let index = index else { return }
            let item = StorageManager.getAllTasksLists()[index].tasks[sourceIndexPath.row]
            StorageManager.makeDoneTask(task: item)
           
            reloadData()
        }
    }
    
    // MARK: - Actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let index = index else { return nil }

        let task = StorageManager.getAllTasksLists()[index].tasks[indexPath.row]
    
        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            StorageManager.deleteTask(task: task)
            self?.reloadData()
        }
    
        let editContextualAction = UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
            self?.alertForAddAndUpdatesTask(tasksTVCFlow: .edditingTask(task: task))
            }
        
        let doneText = task.isComplete ? "Not done" : "Done"
        let doneContextualAction = UIContextualAction(style: .destructive, title: doneText)  { [weak self] _, _, _  in
            StorageManager.makeDoneTask(task: task)
            self?.reloadData()
        }
      
        deleteContextualAction.backgroundColor = .red
        editContextualAction.backgroundColor = .gray
        doneContextualAction.backgroundColor = .green
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteContextualAction, editContextualAction, doneContextualAction])
    
        return swipeActionsConfiguration
    }

    // MARK: - Private func
    private func reloadData() {
        guard let index = index else { return }
        let list = StorageManager.getAllTasksLists()[index]
        title = list.name
        data.removeAll()
        data.append(list.tasks.filter("isComplete = false").map({ $0.mapToModel()}))
        data.append(list.tasks.filter("isComplete = true").map({ $0.mapToModel()}))
        tableView.reloadData()
    }
    
    @objc
    private func addBarButtonItemSelector() {
        alertForAddAndUpdatesTask(tasksTVCFlow: TasksTVCFlow.addingNewTask)
    }
    
    @objc
    private func editBarButtonItemSelector() {
        tableView.isEditing.toggle()
    }
    
    private func alertForAddAndUpdatesTask(tasksTVCFlow: TasksTVCFlow) {
        let textAlertData = TextAlertData(tasksTVCFlow: tasksTVCFlow)
        
        let alert = UIAlertController(title: textAlertData.titleForAlert,
                                                message: textAlertData.messageForAlert,
                                                preferredStyle: .alert)
    
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        ///  добавляем и настраиваем TextField
        alert.addTextField { textField  in
            taskTextField = textField
            taskTextField.placeholder = textAlertData.newTextFieldPlaceholder
            taskTextField.text = textAlertData.taskName
        }
        
        alert.addTextField { textField  in
            noteTextField = textField
            noteTextField.placeholder = textAlertData.noteTextFieldPlaceholder
            noteTextField.text = textAlertData.tasknato
        }
        
        /// добавляем и настраиваем Actionы
        let saveAction = UIAlertAction(title: textAlertData.doneButtinForAlert, style: .default) { [weak self] _ in
            guard let self = self,
                  let newTaskName = taskTextField.text, !newTaskName.isEmpty,
                  let noteTask = noteTextField.text, !noteTask.isEmpty,
                  let index = self.index
            else { return }
            
            switch tasksTVCFlow {
            case .addingNewTask:
                let task = Task()
                task.name = newTaskName
                task.note = noteTask
                let currentTasksList = StorageManager.getAllTasksLists()[index]
                StorageManager.saveTask(tasksList: currentTasksList, task: task)
                
                ///созраняем новую таску
            case .edditingTask(task: let task):
                StorageManager.editTask(task: task, newName: newTaskName, newNote: noteTask)
            }
            self.reloadData()
        }
        
        let calcelAction = UIAlertAction(title: textAlertData.canclTxt, style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(calcelAction)
        
        present(alert, animated: true)
    }
}
