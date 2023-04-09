//
//  TaskModel.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-03-16.
//

import Foundation

struct TaskModel:Encodable,Decodable{
    var taskId:Int
    var dateTime:Date
    var task:String
    var isDone:Bool

}
