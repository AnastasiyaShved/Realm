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

    var currentTasksList: TasksList?
    
    // убрать !
    private var notCompletedTasks: Results<Task>!
    private var compleated: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList?.name
        /// фильтрация тасок
        filteringTasks()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemSelector))
        navigationItem.setRightBarButton(add, animated: true)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ///определяем, в какой секции сейчас находимся
        section == 0 ? notCompletedTasks.count : compleated.count
    }
        ///настраиваем названия секциий ( можно  сделать чепез более кастомно настройкиviewForFooterInSection)
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Not completed tasks" : "Completed tasks"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = indexPath.section == 0 ? notCompletedTasks?[indexPath.row] : compleated[indexPath.row]
        cell.textLabel?.text = task?.name
        cell.detailTextLabel?.text = task?.note
        return cell
    }
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // MARK: - Actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : compleated[indexPath.row]
    
        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            StorageManager.deletTask(task: task)
            self?.filteringTasks()
        }
    
        let editContextualAction = UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
            self?.alertForAddAndUpdatesTask(tasksTVCFlow: .edditingTask(task: task))
            }
        
        let doneText = task.isComplete ? "Not done" : "Done"
        let doneContextualAction = UIContextualAction(style: .destructive, title: doneText)  { [weak self] _, _, _  in
            StorageManager.makeDoneTask(task: task)
            self?.filteringTasks()
        }
      
        deleteContextualAction.backgroundColor = .red
        editContextualAction.backgroundColor = .gray
        doneContextualAction.backgroundColor = .green
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteContextualAction, editContextualAction, doneContextualAction])
    
        return swipeActionsConfiguration
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // MARK: - Private func
    private func filteringTasks() {
        notCompletedTasks = currentTasksList?.tasks.filter("isComplete = false")
        compleated = currentTasksList?.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
    
    @objc
    private func addBarButtonItemSelector() {
        alertForAddAndUpdatesTask(tasksTVCFlow: TasksTVCFlow.addingNewTask)
    }
    
    private func alertForAddAndUpdatesTask(tasksTVCFlow: TasksTVCFlow) {
        let textAlertData = TextAlertData(tasksTVCFlow: tasksTVCFlow)

        
        let alert = UIAlertController(title: textAlertData.titleForAlert,
                                                message: textAlertData.messageForAlert,
                                                preferredStyle: .alert)
        
        ///!!! UITextField !
        var taskTextField: UITextField!
        
        var noteTextField: UITextField!
        
        ///  доьавляем и настроиваем TextField
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
                  let currentTasksList = self.currentTasksList
            else { return }
            
            switch tasksTVCFlow {
            case .addingNewTask:
                let task = Task()
                task.name = newTaskName
                task.note = noteTask
                StorageManager.saveTask(tasksList: currentTasksList, task: task)
                ///созраняем новую таску
            case .edditingTask(task: let task):
                StorageManager.editTask(task: task, newName: newTaskName, newNote: noteTask)
            }
            self.filteringTasks()
        }
        
        let calcelAction = UIAlertAction(title: textAlertData.canclTxt, style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(calcelAction)
        
        
        present(alert, animated: true)
    }
}
