//
//  UItableViewCellExt.swift
//  RealmProject
//
//  Created by Apple on 6.11.23.
//

import UIKit

extension UITableViewCell {
    
    func configure(with list: TasksList) {
        
        let notCompletedTask = list.tasks.filter("isComplete = false")
        let completedTask = list.tasks.filter("isComplete = true")
        
        textLabel?.text = list.name
        
        if !notCompletedTask.isEmpty {
            configureCell(
                text: "\(notCompletedTask.count)",
                textColor: .red)
        } else if !completedTask.isEmpty {
            configureCell(
                text: "✓",
                font: .systemFont(ofSize: 24),
                textColor: .green)
        } else {
            configureCell(
                text: "0",
                textColor: .black)
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
    
    private func configureCell(text: String, font: UIFont = .systemFont(ofSize: 17), textColor: UIColor) {
        detailTextLabel?.text = text
        detailTextLabel?.font = font
        detailTextLabel?.textColor = textColor
    }
}
