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
    
    
    //get TaskBrain referance
    let dateFormatter = DateFormatter()
    var date:Date?
    var currentTask:String?
    var isSort = false
    
    var taskBrain = TaskBrain()
    
    
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
    
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        textFieldDidEndEditing(taskTextField)
        
        if currentTask != nil && date != nil{
            DispatchQueue.main.async {
                let newTask = TaskModel(taskId: (TaskBrain.tasks.count), dateTime: self.date!,task: self.currentTask!, isDone: false)
                
                self.taskBrain.addTask(task: newTask)
                
                
                
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
}

//MARK: - UITableviwDataSource
extension ViewController:UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskBrain.tasks.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reUsableCell, for: indexPath)
        as! TaskCell
        
        let task = TaskBrain.tasks[indexPath.row]
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
            TaskBrain.tasks.remove(at: indexPath.row)
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
        let movedObject = TaskBrain.tasks[sourceIndexPath.row]
        TaskBrain.tasks.remove(at: sourceIndexPath.row)
        TaskBrain.tasks.insert(movedObject, at: destinationIndexPath.row)
        TaskBrain.updateTaskId()
        print("updated task list = \(TaskBrain.tasks)")
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
        TaskBrain.tasks[indexPath.row].isDone = !TaskBrain.tasks[indexPath.row].isDone
        taskTableView.reloadData()
    }
    
    
}

//MARK: - long press gesture
extension ViewController{
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: taskTableView)
            if let indexPath = taskTableView.indexPathForRow(at: touchPoint) {
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : EditTaskController = storyboard.instantiateViewController(withIdentifier: "EditScreen") as! EditTaskController
                vc.taskId = indexPath.row//change
                vc.taskTitle = TaskBrain.tasks[indexPath.row].task
                vc.isDone = TaskBrain.tasks[indexPath.row].isDone
                
                vc.modalPresentationStyle = .pageSheet
                if
                    #available(iOS 15.0, *),
                    let sheet = vc.sheetPresentationController
                {
                    sheet.detents = [.medium(),.large()]
                    present(vc, animated: true)
                }else{
                    show(vc, sender: true)
                }
                
            }
        }
    }
}

