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
    var selectedCategory:CategoryEntity? {
        didSet{
            loadTasks()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.name
        
        taskTextField.delegate = self
        taskTableView.delegate = self
        taskTableView.dataSource = self
        searchBar.delegate = self
        
        taskTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        taskTableView.isEditing = false
        taskTableView.allowsSelectionDuringEditing = false
        
        setCurrentDateAndTime()
        self.taskTableView.reloadData()
        
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
                newTask.parentCategory = self.selectedCategory
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("is Woring?")
        taskTextField.resignFirstResponder()
    }
}
