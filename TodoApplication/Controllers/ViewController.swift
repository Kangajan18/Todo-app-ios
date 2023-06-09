//
//  ViewController.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-03-16.
//

import UIKit
import CoreData

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
    var taskArray:[TaskEntity] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    }
    
    func saveTask() {
        do{
            try context.save()
        } catch {
            print("Error while save Date ,\(error)")
        }
        taskTableView.reloadData()
    }
    
    func loadTasks() {
        let request : NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

        do {
            taskArray = try context.fetch(request)
        } catch {
            print("Error fetching data form context \(error)")
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
}
