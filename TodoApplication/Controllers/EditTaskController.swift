//
//  EditTaskController.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-03-19.
//

import UIKit

class EditTaskController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var updateTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var isDownSegmentedControl: UISegmentedControl!
    
    
    var date:Date?
    var taskId:Int?
    var taskTitle:String?
    var isDone:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTextField.delegate = self
        
        let selectedTask = TaskBrain.getTaskById(taskId: taskId!)
                                
        if selectedTask != nil{
            date = selectedTask?.dateTime
            taskTitle = selectedTask?.task
        }
        updateTextField.becomeFirstResponder()
        DispatchQueue.main.async { [self] in
            updateTextField.text = taskTitle
            isDownSegmentedControl.selectedSegmentIndex = isDone == true ? 0 : 1
            isDownSegmentedControl.selectedSegmentTintColor = isDone == true ? .systemGreen : UIColor(named: "screen1SecondaryColor")
        }
       
        
    }

    
    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    

    
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        isDone = !isDone!
        isDownSegmentedControl.selectedSegmentTintColor = isDone == true ? .systemGreen : UIColor(named: "screen1SecondaryColor")
    }
    
    @IBAction func updateTaskButtonPressed(_ sender: UIButton) {
        TaskBrain.updateTask(taskId: taskId!, taskTitle: updateTextField.text!, taskDate: date!, isDone: isDone!)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : ViewController = storyboard.instantiateViewController(withIdentifier: "screenEnterTodo") as! ViewController
                self.show(vc, sender: self)
    }
    
}
