//
//  ViewController.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-03-16.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    
    //get TaskBrain referance
    let dateFormatter = DateFormatter()
    var date:Date?
    var currentTask:String?
    var isSort = false
    var taskArray:[TaskModel] = []
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTextField.delegate = self
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        taskTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        taskTableView.isEditing = false
        taskTableView.allowsSelectionDuringEditing = false
        
        setCurrentDateAndTime()
        self.taskTableView.reloadData()
        
        navigationItem.hidesBackButton = true
        
        if let data = UserDefaults.standard.object(forKey: "TodoList") as? Data,
           let items = try? JSONDecoder().decode([TaskModel].self, from: data) {
            taskArray = items
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        taskTableView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject?) {
        textFieldDidEndEditing(taskTextField)
        
        if currentTask != nil && date != nil{
            DispatchQueue.main.async {
                let newTask = TaskModel(taskId: (self.taskArray.count), dateTime: self.date!,task: self.currentTask!, isDone: false)
                self.taskArray.append(newTask)
                if let encoded = try? JSONEncoder().encode(self.taskArray) {
                    self.defaults.set(encoded, forKey: "TodoList")
                }
                self.taskTableView.reloadData()
            }
        }
        
        
        taskTextField.text = ""
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
