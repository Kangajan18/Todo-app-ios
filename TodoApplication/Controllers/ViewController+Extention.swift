//
//  ViewController+Extention.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-04-10.
//

import Foundation
import UIKit
import CoreData


//MARK: - UITextFieldDelegate
extension ViewController:UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != ""{
            currentTask = textField.text!
            textField.placeholder = "Enter Your Task here"
        }else{
            textField.placeholder = "Type Your Task here"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addButtonPressed(nil)
        DispatchQueue.main.async {
            self.taskTextField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - UITableviwDataSource
extension ViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reUsableCell, for: indexPath)
        as! TaskCell
        
        let task = taskArray[indexPath.row]
        cell.taskLabel.text = task.task
        cell.dateLabel.text = getFormattedDate(date: task.dateTime!, format: "MMM d, h:mm a")
        cell.taskImage.image = UIImage(imageLiteralResourceName: getApopriateIcon(to: task.task!))
        cell.taskBubble.backgroundColor = task.isDone == true ? .systemGreen : UIColor(named: "screen1SecondaryColor")
        return cell
    }
    
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            context.delete(taskArray[indexPath.row])
            taskArray.remove(at: indexPath.row)
            self.saveTask()
            tableView.reloadData()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        taskTableView.setEditing(editing, animated: true)
        self.taskTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = taskArray[sourceIndexPath.row]
        taskArray.remove(at: sourceIndexPath.row)
        taskArray.insert(movedObject, at: destinationIndexPath.row)
    }
}

//MARK: - IconSelection
extension ViewController{
    func getApopriateIcon(to task:String)->String{
        let taskArray = task.lowercased().split(separator: " ")
        for taskname in taskArray{
            
            if let enumCase = Tasks(rawValue: String(taskname)) {
                return enumCase.rawValue
            }
        }
        return "task"
    }
}

//MARK: - UITableViewDelegate
extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskArray[indexPath.row].isDone = !taskArray[indexPath.row].isDone
        taskTableView.reloadData()
        self.saveTask()
    }
}

//MARK: - long press gesture(update)
extension ViewController{
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        var textField = UITextField()
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: taskTableView)
            if let indexPath = taskTableView.indexPathForRow(at: touchPoint) {
                
                
                let updatePopUp = UIAlertController(title: "Update Task", message: "", preferredStyle: .alert)
                let updateAction = UIAlertAction(title: "Update", style: .default) { [unowned self] updateAction in
                    
                    if let taskItem = textField.text{
                        taskArray[indexPath.row].task = taskItem
                        taskTableView.reloadData()
                        saveTask()
                    }
                }
                
                updatePopUp.addTextField { updateTextField in
                    updateTextField.text = self.taskArray[indexPath.row].task
                    textField = updateTextField
                    textField.becomeFirstResponder()
                }
                updatePopUp.addAction(updateAction)
                present(updatePopUp, animated: true) {
                    textField.becomeFirstResponder()
                }
            }
        }
    }
}

//MARK: - coredata data manipulation
extension ViewController {
    func saveTask() {
        do{
            try context.save()
        } catch {
            print("Error while save Date ,\(error)")
        }
        taskTableView.reloadData()
    }
    
    func loadTasks(with request:NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest(),_ predicate:NSPredicate? = nil) {
        
        if let selectedCategoryName = selectedCategory?.name {
            
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",                                selectedCategoryName)
            
            if let newPredicate = predicate {
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,newPredicate])
                request.predicate = compoundPredicate
            } else {
                request.predicate = categoryPredicate
            }
            
            do {
                if try context.fetch(request) != []{
                    taskArray = try context.fetch(request)
                } else {
                    let noTaskPopUp = UIAlertController(title: "No Task Found", message: "Please use other works to find your task.", preferredStyle: .alert)
                    let actionButton = UIAlertAction(title: "Ok", style: .default)
                    
                    noTaskPopUp.addAction(actionButton)
                    present(noTaskPopUp, animated: true)
                }
            } catch {
                print("Error fetching data form context \(error)")
            }
        }
    }
}


//MARK: - searchBar delegate
extension ViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            print("is call again?")
            loadTasks()
            taskTableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            searchAutomatically()
        }
    }
    
    private func searchAutomatically() {
        
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        var predicate:NSPredicate?
        if let taskName = searchBar.text {
            predicate = NSPredicate(format: "task CONTAINS %@", taskName.lowercased())
        }
        request.sortDescriptors = [NSSortDescriptor(key: "task", ascending: true)]
        
        loadTasks(with: request,predicate)
        taskTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
