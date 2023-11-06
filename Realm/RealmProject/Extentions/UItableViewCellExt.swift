//
//  UItableViewCellExt.swift
//  RealmProject
//
//  Created by Apple on 6.11.23.
//

import UIKit

extension UITableViewCell {
    
    
    
    func configure(with list: TasksList) {
        let notCompletedTask = list.tasks.filter("isComplete =  false")
        let completedTask = list.tasks.filter("isComplete =  true")
        
        textLabel?.text = list.name
        
        if !notCompletedTask.isEmpty {
            detailTextLabel?.text = "\(notCompletedTask.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .red
        } else if !completedTask.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 24)
            detailTextLabel?.textColor = .green
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .black
        }
        
//        switch list {
//        case !notCompletedTask.isEmpty:
//            detailTextLabel?.text = "\(notCompletedTask.count)"
//            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
//            detailTextLabel?.textColor = .red
//        case !completedTask.isEmpty:
//            detailTextLabel?.text = "\(notCompletedTask.count)"
//            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
//            detailTextLabel?.textColor = .red
//        default {
//            detailTextLabel?.text = "0"
//            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
//            detailTextLabel?.textColor = .black
//        }
//
//        }
        
        
        
        
        
    }
}
