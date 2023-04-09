//
//  TaskBrain.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-03-16.
//

import Foundation


struct TaskBrain{

    var viewController = ViewController()
    
    func addTask(task:TaskModel?){
        if let currentTask = task, task != nil{
            viewController.taskArray.append(currentTask)
        }else{
            print("Error task not added")
        }
    }

    func updateTaskId(){
        for i in 0...viewController.taskArray.count - 1 {
            viewController.taskArray[i].taskId = i
        }
    }

    func getTaskById(taskId:Int)->TaskModel?{
        for task in viewController.taskArray{
            if task.taskId == taskId{
                return task
            }
        }
        return nil
    }

    func updateTask(taskId:Int,taskTitle:String,taskDate:Date,isDone:Bool){
        print("TaskId = \(taskId) \(taskTitle)")
        viewController.taskArray[taskId].task = taskTitle
        viewController.taskArray[taskId].dateTime = taskDate
        viewController.taskArray[taskId].isDone = isDone
    }

    func updateTaskIsDone(taskId:Int,isDone:Bool){
        viewController.taskArray[taskId].isDone = isDone
    }
}
