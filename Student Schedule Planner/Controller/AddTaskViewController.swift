//
//  AddTaskViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {
    
    let realm = try! Realm()
    var hour:Int = 0
    var minutes:Int = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Properties
    let topView = makeTopView(height: 90)
    let titleLabel = makeTitleLabel(withText: "Add Task")
    let backButton = makeBackButton()
    let titleHeading = makeHeading(withText: "Title")
    let startDatePicker = makeDatePicker()
    let titleTextField = makeTextField(withPlaceholder: "Title")
    let startDateHeading = makeHeading(withText: "Start Date")
    let durationHeading = makeHeading(withText: "Duration")
    let durationPickerView = UIPickerView()
    let saveButton = makeSaveButton()
    let deleteButton = makeDeleteButton()
    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(titleHeading)
        view.addSubview(titleTextField)
        view.addSubview(startDateHeading)
        view.addSubview(startDatePicker)
        view.addSubview(durationHeading)
        view.addSubview(saveButton)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.addSubview(deleteButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.anchor(top: topView.topAnchor, paddingTop: 40)
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        deleteButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        deleteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        
        titleHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        titleTextField.centerX(in: view)
        titleTextField.anchor(top: titleHeading.bottomAnchor, paddingTop: 5)
        
        startDateHeading.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 20)
        startDatePicker.centerX(in: view)
        startDatePicker.anchor(top: startDateHeading.bottomAnchor)
        
        durationHeading.anchor(top: startDatePicker.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 20)
        setUpDurationPickerView()
        
        saveButton.centerX(in: view)
        saveButton.anchor(top: durationPickerView.bottomAnchor, paddingTop: 50)
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        if let taskIndex = TaskService.shared.getTaskIndex() {
            if let task = TaskService.shared.getTask(atIndex: taskIndex) {
                titleTextField.text = task.title
                startDatePicker.date = task.startDate
                
                let calendar = Calendar.current
                let timeComponents = calendar.dateComponents([.hour, .minute], from: task.endDate)
                let nowComponents = calendar.dateComponents([.hour, .minute], from: startDatePicker.date)
                
                let difference = abs(calendar.dateComponents([.minute], from: nowComponents, to: timeComponents).minute!)
                print(difference)
                let hours = difference / 60
                let minutes = difference - (hours * 60)
                durationPickerView.selectRow(hours, inComponent:0, animated: false)
                durationPickerView.selectRow(minutes, inComponent:3, animated: false)
            }
        }
    }
    
    func setUpDurationPickerView() {
        view.addSubview(durationPickerView)
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
        
        durationPickerView.anchor(top: durationHeading.bottomAnchor, paddingTop: 5)
        durationPickerView.centerX(in: view)
        durationPickerView.setDimensions(width: UIScreen.main.bounds.width-140, height: 120)
        durationPickerView.backgroundColor = .backgroundColor
    }
    
    //MARK: - Actions
    @objc func saveTask() {
        
            let duration = hour*3600 + minutes * 60
            var endDate = startDatePicker.date
            endDate.addTimeInterval(TimeInterval(duration))
            
            let task = Task()
            task.title = titleTextField.text ?? ""
            task.startDate = startDatePicker.date
            task.endDate = endDate
            
            if !checkForTimeConflict(startTime: task.startDate, endDateTime: task.endDate) {
                do {
                    try realm.write {
                        if TaskService.shared.getTaskIndex() != nil {
                        
                        let updatedTask = realm.objects(Task.self).filter("startDate == \(task.startDate)").first
                            updatedTask?.title = task.title
                            updatedTask?.startDate = startDatePicker.date
                            updatedTask?.endDate = endDate
                    } else{
                            let day = Day()
                            day.date = task.startDate
                            day.tasks.append(task)
                            realm.add(day)
                            realm.add(task)
                        }
                    }
                } catch {
                    print("Error writing task to realm, \(error.localizedDescription)")
                }
                TaskService.shared.updateTasks()
                dismiss(animated: true)
            }
    }
    
    @objc func deleteTask() {
        do {
            try realm.write {
                if let taskIndex = TaskService.shared.getTaskIndex() {
                    if let taskToDelete = TaskService.shared.getTask(atIndex: taskIndex) {
                        realm.delete(taskToDelete)
                        TaskService.shared.updateTasks()
                    }
                }
            }
        } catch {
            print("Error writing task to realm")
        }
        dismiss(animated: true) {
            TaskService.shared.setTaskIndex(index: nil)
        }
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true) {
             TaskService.shared.setTaskIndex(index: nil)
        }
    }
    
    //MARK: - Helper methods
    func checkForTimeConflict(startTime: Date, endDateTime: Date) -> Bool{
        
        //1) A previous tasks start time is in between the current tasks start and end times
        let conflictCheck1 = realm.objects(Task.self).filter("startDate > %@ AND startDate < %@", startTime, endDateTime)
        if conflictCheck1.count > 0 {
            showAlert()
            return true
        }
        
        //2) A previous tasks end time is in between the current tasks start and end times
        let conflictCheck2 = realm.objects(Task.self).filter("endDate > %@ AND endDate < %@", startTime, endDateTime)
        if conflictCheck2.count > 0 {
            showAlert()
            return true
        }
        
        //3) The current tasks start time is in between a previous taks start and end time
        let conflictCheck3 = realm.objects(Task.self).filter("startDate < %@ AND endDate > %@", startTime, startTime)
        if conflictCheck3.count > 0 {
            showAlert()
            return true
        }
        
        //4) The current tasks end time is in between a previous taks start and end time
        let conflictCheck4 = realm.objects(Task.self).filter("startDate < %@ AND endDate > %@", endDateTime, endDateTime)
        if conflictCheck4.count > 0 {
            showAlert()
            return true
        }
        return false
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Schedule Conflict", message: "You have another event that overlaps. Please change the time of either this event or the other conflicting one", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
//MARK: - Pickerview delegate and datasource
extension AddTaskViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1, 4:
            return 1
        case 3:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return pickerView.frame.size.width/6
        case 1:
            return pickerView.frame.size.width/4
        case 2:
            return pickerView.frame.size.width/8
        case 3:
            return pickerView.frame.size.width/6
        case 4:
            return pickerView.frame.size.width/4
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "hours"
        case 3:
            return "\(row)"
        case 4:
            return "min"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            hour = row
        case 3:
            minutes = row
        default:
            break;
        }
    }
}
