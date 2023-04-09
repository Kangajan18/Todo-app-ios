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
    
//    var taskBrain = TaskBrain()
    
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

//MARK: - UITextFieldDelegate

extension ViewController:UITextFieldDelegate{
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != ""{
            currentTask = textField.text!
            textField.placeholder = "Enter Your Task here"
        }else{
            _ = textFieldShouldEndEditing(textField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addButtonPressed(nil)
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
        cell.dateLabel.text = getFormattedDate(date: task.dateTime, format: "MMM d, h:mm a")
        cell.taskImage.image = UIImage(imageLiteralResourceName: getApopriateIcon(task: task.task))
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
            taskArray.remove(at: indexPath.row)
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
        //taskBrain.updateTaskId()
    }
}

extension ViewController{
    func getApopriateIcon(task:String)->String{
        
        let taskArray = task.lowercased().split(separator: " ")
        
        for taskname in taskArray{
            
            switch taskname{
            case "study":
                return "study"
            case "game":
                return "game"
            case "cricket":
                return "cricket"
            case "football":
                return "football"
            case "hiking":
                return "hiking"
            case "jogging":
                return "jogging"
            case "badminton":
                return "badminton"
            case "meeting":
                return "meeting"
            case "coding":
                return "coding"
            case "music":
                return "music"
            case "gym":
                return "gym"
            default:
                continue
            }
        }
        
        return "task"
    }
}

//MARK: - UITableViewDelegate
extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Single touch working")
        print(taskArray[indexPath.row].isDone)
        taskArray[indexPath.row].isDone = !taskArray[indexPath.row].isDone
        print(taskArray[indexPath.row].isDone)
        taskTableView.reloadData()
    }
}

//MARK: - long press gesture
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

