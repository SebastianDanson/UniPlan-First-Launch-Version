//
//  WeekCell.swift
//  UniPlan
//
//  Created by Student on 2020-07-15.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class taskButton: UIButton {
    var id : String?
}

class WeekCell: UITableViewCell {
    
    //MARK: - lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    let view = makeTaskView()
    let dayLabel = makeLabel(ofSize: 12, weight: .regular)
    let numLabel = makeLabel(ofSize: 16, weight: .bold)
    let scrollView = UIScrollView()
    //MARK: - setupUI
    func setupViews() {
        backgroundColor = .backgroundColor
        
        addSubview(view)
        view.addSubview(dayLabel)
        view.addSubview(numLabel)
        
        view.layer.borderColor = UIColor.clear.cgColor
        view.anchor(top: topAnchor,
                    left: leftAnchor,
                    right: rightAnchor,
                    bottom: bottomAnchor)
        
        dayLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        dayLabel.anchor(left: view.leftAnchor, paddingLeft: 10)
        
        numLabel.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor, constant: -2).isActive = true
        numLabel.anchor(top: dayLabel.bottomAnchor)
        
        view.addSubview(scrollView)
        scrollView.setDimensions(width: UIScreen.main.bounds.width - 45, height: UIScreen.main.bounds.height / 9.55 + 13)
        scrollView.anchor(left: view.leftAnchor, paddingLeft: 42)
        scrollView.centerY(in: view)
        scrollView.isScrollEnabled = true
        
        view.backgroundColor = .backgroundColor
        
    }
    
    @objc func taskPressed(sender: taskButton) {
        let task = realm.objects(Task.self).filter("id == %@" , sender.id).first
        TaskService.shared.setSelectedTask(task: task)
        
        let vc = AddTaskViewController()
        vc.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func update(date: Date) {
        
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        
        let theDate = formatDateNoTime(from: date)
        let day = theDate.substring(to: theDate.firstIndex(of: " ")!)
        let num = theDate.substring(from: theDate.firstIndex(of: " ")!)
        
        self.dayLabel.text = day
        self.numLabel.text = num
        
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.startOfDay(for: date.addingTimeInterval(86400))
        
        let tasks = realm.objects(Task.self).filter("startDate >= %@ AND startDate <= %@" , startDate, endDate).sorted(byKeyPath: "startDate", ascending: true)
        
        var index = 0
        for task in tasks {
            let taskView = taskButton()
            taskView.id = task.id
            let title = makeLabel(ofSize: 12, weight: .bold)
            let timeLabel = makeLabel(ofSize: 11, weight: .semibold)
            let overlay = taskButton()
            let checkImageView = UIImageView(image: UIImage(named: "check"))
            
            self.scrollView.addSubview(taskView)
            taskView.addSubview(title)
            taskView.addSubview(timeLabel)
            taskView.addSubview(overlay)
            overlay.addSubview(checkImageView)
            
            taskView.setDimensions(width: 70, height: UIScreen.main.bounds.height/9.55 + 13)
            taskView.backgroundColor = UIColor(red: CGFloat(task.color[0]), green: CGFloat(task.color[1]), blue: CGFloat(task.color[2]), alpha: 0.8)
            taskView.anchor(left: self.scrollView.leftAnchor, paddingLeft: CGFloat(index*70))
            taskView.centerY(in: self.scrollView)
            taskView.addTarget(self, action: #selector(self.taskPressed(sender:)), for: .touchUpInside)
            
            title.text = task.title == "" ? "Untitled":task.title
            title.anchor(top: taskView.topAnchor,
                         left: taskView.leftAnchor,
                         paddingTop: UIScreen.main.bounds.height/180,
                         paddingLeft: 5)
            title.widthAnchor.constraint(lessThanOrEqualToConstant: 60).isActive = true
            title.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height/8 - 35).isActive = true
            title.textColor = UIColor(red: 30/255, green: 39/255, blue: 46/255, alpha: 1)
            timeLabel.textColor = UIColor(red: 30/255, green: 39/255, blue: 46/255, alpha: 1)
            title.numberOfLines = 0
            
            timeLabel.text = "\(formatTime(from: task.startDate))-\n\(formatTime(from: task.endDate))"
            timeLabel.centerX(in: taskView)
            timeLabel.anchor(bottom: taskView.bottomAnchor, paddingBottom: 1)
            timeLabel.numberOfLines = 0
            
            overlay.setDimensions(width: 70)
            overlay.anchor(top: taskView.topAnchor,
                           bottom: taskView.bottomAnchor)
            overlay.backgroundColor = UIColor(red: 11/255, green: 232/255, blue: 129/255, alpha: 0.3)
            overlay.centerX(in: taskView)
            overlay.id = task.id
            overlay.addTarget(self, action: #selector(self.taskPressed(sender:)), for: .touchUpInside)
            
            checkImageView.centerX(in: overlay)
            checkImageView.centerY(in: overlay)
            checkImageView.setDimensions(width: 50, height: 50)
            
            if task.isComplete {
                overlay.isHidden = false
            } else  {
                overlay.isHidden = true
            }
            
            index += 1
        }
        
        let size = CGSize(width: CGFloat(index*70), height:UIScreen.main.bounds.height/9.2 + 7.6)
        
        self.scrollView.contentSize = size
    }
}

