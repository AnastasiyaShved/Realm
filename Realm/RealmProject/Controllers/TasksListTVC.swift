//
//  TasksListTVC.swift
//  Realm
//
//  Created by Apple on 31.10.23.
//

import UIKit
import RealmSwift

class TasksListTVC: UITableViewController {
    // Results - для отображения актуальных данных
    var list: Results<TasksList>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
//        StorageManager.deleteAll()
        
        list = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
       
        ///создание кнопки по добавлению списка
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemSelector))
        ///отображение кнопки на экране
        navigationItem.setRightBarButton(add, animated: true)
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        let byKeyPath = sender.selectedSegmentIndex == 0 ? "name" : "date"
        list = list?.sorted(byKeyPath: byKeyPath)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let taskList = list?[indexPath.row]
        cell.textLabel?.text = taskList?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // MARK: - ContextualAction
   ///метод  для выбора несколькиз варинтов реактирование/удание   тп
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let currentList = list?[indexPath.row] else { return nil}
        
        //создаем кнопок
        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            StorageManager.deleteList(tasksList: currentList)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    
        let editContextualAction = UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
            self?.alertForAddAndUpdatesTasksList(currentList: currentList, indexPath: indexPath)
            }
        
        let doneContextualAction = UIContextualAction(style: .destructive, title: "Done")  { [weak self] _, _, _  in
            StorageManager.makeAllDone(tasksList: currentList)
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
      
        deleteContextualAction.backgroundColor = .red
        editContextualAction.backgroundColor = .gray
        doneContextualAction.backgroundColor = .green
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteContextualAction, editContextualAction, doneContextualAction])
    
        return swipeActionsConfiguration
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TasksTVC,
           let indexPath = tableView.indexPathForSelectedRow {
            let currentTasksList = list?[indexPath.row]
            destinationVC.currentTasksList = currentTasksList
        }
    }

    // MARK: - Private func
    @objc
    private func addBarButtonItemSelector() {
        alertForAddAndUpdatesTasksList()
    }
    ///создание и заполнение alertController
    private func alertForAddAndUpdatesTasksList(currentList: TasksList? = nil, indexPath: IndexPath? = nil) {
        let title = currentList == nil ? "New list" : "Edit list"
        let message = "Please insert list's name"
        let doneButtName = currentList == nil ? "Save" : "Updata"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ///!!! UITextField !
        var alertTextField: UITextField = UITextField()
        
        let saveAction = UIAlertAction(title: doneButtName, style: .default) { [weak self] _ in
            guard let self = self,
                  let newListName = alertTextField.text,
                  !newListName.isEmpty else { return }
            /// логика редактирования
            if let currentList = currentList,
            let indexPath = indexPath {
                StorageManager.editeList(tasksList: currentList, newListName: newListName)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                ///логика coздание нового обьекта
                let taskList = TasksList()
                taskList.name = newListName
                StorageManager.saveTasksList(tasksList: taskList)
                self.tableView.reloadData()
            }
        }
        //можно  оработать
        let calcelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(calcelAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            if let currentList = currentList {
                alertTextField.text = currentList.name
            }
            alertTextField.placeholder = "List name"
        }
        present(alertController, animated: true)
    }
}
