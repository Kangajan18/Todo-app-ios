//
//  TaskBrain.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-03-16.
//

import Foundation


struct TaskBrain{

    static var tasks:[TaskModel] = []

    func addTask(task:TaskModel?){
        if task != nil{
            TaskBrain.tasks.append(task!)
            print("TAsk added")
            print("Task = \(TaskBrain.tasks.count)")
        }else{
            print("Error task not added")
        }
    }

    static func updateTaskId(){
        for i in 0...TaskBrain.tasks.count - 1 {
            TaskBrain.tasks[i].taskId = i
        }
    }

    static func getTaskById(taskId:Int)->TaskModel?{
        for task in TaskBrain.tasks{
            if task.taskId == taskId{
                return task
            }
        }
        return nil
    }

    static func updateTask(taskId:Int,taskTitle:String,taskDate:Date,isDone:Bool){
        updateTaskId()
        print("TaskId = \(taskId) \(taskTitle)")

        TaskBrain.tasks[taskId].task = taskTitle
        TaskBrain.tasks[taskId].dateTime = taskDate
        TaskBrain.tasks[taskId].isDone = isDone
    }

    static func updateTaskIsDone(taskId:Int,isDone:Bool){
        TaskBrain.tasks[taskId].isDone = isDone
    }
}
