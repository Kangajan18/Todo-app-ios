//
//  ViewController.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-03-16.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    //define uiElements
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //get TaskBrain referance
    let dateFormatter = DateFormatter()
    var date:Date?
    var currentTask:String?
    var isSort = false
    var taskArray:[TaskEntity] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTextField.delegate = self
        taskTableView.delegate = self
        taskTableView.dataSource = self
        searchBar.delegate = self
        
        taskTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        taskTableView.isEditing = false
        taskTableView.allowsSelectionDuringEditing = false
        
        setCurrentDateAndTime()
        self.taskTableView.reloadData()
        
        navigationItem.hidesBackButton = true
        //load data
        loadTasks()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        taskTableView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject?) {
        textFieldDidEndEditing(taskTextField)
        
        if currentTask != nil && date != nil{
            DispatchQueue.main.async {
                
                let newTask = TaskEntity(context: self.context)
                
                newTask.taskId = Int32(self.taskArray.count)
                newTask.task = self.currentTask
                newTask.dateTime = self.date
                newTask.isDone = false
                
                self.taskArray.append(newTask)
                
                self.saveTask()
            }
        }
        taskTextField.text = ""
        DispatchQueue.main.async {
            self.taskTextField.resignFirstResponder()
        }
    }
    
    func saveTask() {
        do{
            try context.save()
        } catch {
            print("Error while save Date ,\(error)")
        }
        taskTableView.reloadData()
    }
    
    func loadTasks(with request:NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()) {
        
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
        taskTableView.reloadData()
    }
    
    @IBAction func datepickerValueChanged(_ sender: UIDatePicker) {
        date = sender.date
        view.endEditing(true)
    }
    
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        isSort = !isSort
        setEditing(isSort, animated: true)
    }
    func setCurrentDateAndTime(){
        date = datePicker.date
    }
}

//MARK: - searchBar delegate
extension ViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTasks()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            searchAutomatically()
        }
    }
    
    private func searchAutomatically() {
        
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        if let taskName = searchBar.text {
            request.predicate = NSPredicate(format: "task CONTAINS %@", taskName.lowercased())
        }
        request.sortDescriptors = [NSSortDescriptor(key: "task", ascending: true)]
        
        loadTasks(with: request)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
