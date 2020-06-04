//
//  TaskCell.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-03.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

   var taskName: String = ""
class TaskCell: UITableViewCell {
    
 
    //MARK: - lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    //MARK: - Properties
    let taskLabel = makeTaskLabel()
    
    private let durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.text = "10:00AM - 12:00PM"
        durationLabel.font = UIFont.systemFont(ofSize: 18)
        durationLabel.textColor = .darkBlue
        
        return durationLabel
    }()
    
    private let taskView: UIView = {
        let taskView = UIView()
        taskView.layer.shadowColor = UIColor.black.cgColor
        taskView.layer.shadowOpacity = 0.1
        taskView.layer.shadowRadius = 0.5
        taskView.layer.shadowOffset = CGSize(width: 0, height: 2)
        taskView.layer.borderWidth = 1
        taskView.layer.borderColor = UIColor.lightGray.cgColor
        taskView.backgroundColor = .lightBlue
        taskView.layer.cornerRadius = 10

        return taskView
    }()
    
    //MARK: - setupUI
    func setupViews() {
        taskLabel.text = taskName
        backgroundColor = .backgroundColor
        addSubview(taskView)
        taskView.addSubview(taskLabel)
        taskView.addSubview(durationLabel)
        
        taskLabel.centerY(in: taskView)
        taskLabel.anchor(left: taskView.leftAnchor, paddingLeft: 30)
        
        durationLabel.centerYAnchor.constraint(equalTo: taskLabel.centerYAnchor).isActive = true
        durationLabel.anchor(right: taskView.rightAnchor, paddingRight:  30)
        
        taskView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, paddingBottom: 5)
    }
    
    //MARK: - Actions
    func update(task: Task) {
        taskLabel.text = task.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        durationLabel.text = "\(dateFormatter.string(from: task.startDate))-\(dateFormatter.string(from: task.endDate))"
    }
    
}
