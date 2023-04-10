//
//  TaskCell.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-03-21.
//

import UIKit

class TaskCell: UITableViewCell {
    
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var taskBubble: UIView!
    @IBOutlet weak var dateBubble: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        taskBubble.layer.cornerRadius = taskBubble.frame.size.height / 10
        dateBubble.layer.cornerRadius = dateBubble.frame.size.height / 15
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
