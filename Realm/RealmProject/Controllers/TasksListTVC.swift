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
    var taskLists: Results<TasksList>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        taskLists = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
       
        ///создание кнопки по добавлению списка
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemSelector))
        ///отображение кнопки на экране
        navigationItem.setRightBarButton(add, animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let taskList = taskLists?[indexPath.row]
        cell.textLabel?.text = taskList?.name
        return cell
    }
    
   
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let tasks = taskLists?[indexPath.row] else { return }
            StorageManager.deleteList(tasksList: tasks)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @objc
    private func addBarButtonItemSelector() {
        alertForAddAndUpdatesTasksList()
    }
    ///создание и заполнение alertController
    private func alertForAddAndUpdatesTasksList() {
        let title = "New list"
        let message = "Please insert list's name"
        let doneButtName = "Save"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var alertTextField: UITextField = UITextField()
        
        let saveAction = UIAlertAction(title: doneButtName, style: .default) { [weak self] _ in
            guard let self = self,
                  let newListName = alertTextField.text,
                  !newListName.isEmpty else {
                return
            }
            
            let taskList = TasksList()
            taskList.name = newListName
            StorageManager.saveTasksList(tasksList: taskList)
            self.tableView.reloadData()
        }
        
        let calcelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(calcelAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List name"
        }
        present(alertController, animated: true)
    }
}
