//
//  AddTaskViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class AddTaskViewController: PickerViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        TaskService.shared.setCheckForTimeConflict(bool: true)
        setupViews()
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: 90)
    let titleLabel = makeTitleLabel(withText: "Add Task")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Not topView
    let titleHeading = makeHeading(withText: "Title")
    let startDatePicker = makeDatePicker(height: 120)
    let titleTextField = makeTextField(withPlaceholder: "Title")
    let startDateHeading = makeHeading(withText: "Start Date")
    let durationHeading = makeHeading(withText: "Duration")
    let durationPickerView = UIPickerView()
    let reminderHeading = makeHeading(withText: "Reminder:")
    let reminderButton = makeRemindersButton()
    let reminderSwitch = UISwitch()
    let saveButton = makeSaveButton()
    
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
        view.addSubview(reminderHeading)
        view.addSubview(reminderButton)
        view.addSubview(reminderSwitch)
        
        //topView
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
        
        //Not topView
        titleHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        titleTextField.centerX(in: view)
        titleTextField.anchor(top: titleHeading.bottomAnchor, paddingTop: 5)
        
        startDateHeading.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 20)
        startDatePicker.centerX(in: view)
        startDatePicker.anchor(top: startDateHeading.bottomAnchor)
        
        durationHeading.anchor(top: startDatePicker.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 20)
        setupDurationPickerView()
        
        reminderHeading.anchor(top: durationPickerView.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 20)
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: 10)
        reminderButton.isHidden = true
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        
        saveButton.centerX(in: view)
        saveButton.anchor(top: reminderButton.bottomAnchor, paddingTop: 50)
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
    
    func setupDurationPickerView() {
        view.addSubview(durationPickerView)
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
        
        durationPickerView.anchor(top: durationHeading.bottomAnchor, paddingTop: 5)
        durationPickerView.centerX(in: view)
        durationPickerView.setDimensions(width: UIScreen.main.bounds.width - 100, height: 120)
        durationPickerView.backgroundColor = .backgroundColor
    }
    
    //MARK: - Actions
    @objc func saveTask() {
        
        let duration = hour*3600 + minutes*60
        var endDate = startDatePicker.date
        endDate.addTimeInterval(TimeInterval(duration))
        
        let task = Task()
        task.title = titleTextField.text ?? ""
        task.startDate = startDatePicker.date
        task.endDate = endDate
        
        if !checkForTimeConflict(startTime: task.startDate, endDateTime: task.endDate, check: TaskService.shared.getCheckForTimeConflict()) {
            do {
                try realm.write {
                    if TaskService.shared.getTaskIndex() != nil {
                        
                        let updatedTask = realm.objects(Task.self).filter("startDate == \(task.startDate)").first
                        updatedTask?.title = task.title
                        updatedTask?.startDate = startDatePicker.date
                        updatedTask?.endDate = endDate
                    } else{
                        let dateOfTask = Calendar.current.startOfDay(for: startDatePicker.date)
                        let endOfDay: Date = {
                            let components = DateComponents(day: 1, second: -1)
                            return Calendar.current.date(byAdding: components, to: dateOfTask)!
                        }()
                        
                        //Check if there is already a date object for the day of the task
                        let day = realm.objects(Day.self).filter("date BETWEEN %@", [dateOfTask, endOfDay]).first
                        if let day = day {
                            day.tasks.append(task)
                        } else {
                            let newDay = Day()
                            newDay.tasks.append(task)
                            realm.add(newDay)
                        }
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
    
    @objc func reminderButtonPressed() {
        let vc = SetReminderViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func reminderSwitchToggled() {
        if reminderSwitch.isOn {
            reminderButton.isHidden = false
        } else {
            reminderButton.isHidden = true
        }
    }
    
    //MARK: - Push notification methods
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    //MARK: - Helper methods
    func checkForTimeConflict(startTime: Date, endDateTime: Date, check: Bool) -> Bool{
        //If the user does not care about the time conflict
        if !check {
            return false
        }
        
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Set Anyways", style: .default, handler: { _ in
            TaskService.shared.setCheckForTimeConflict(bool: false)
            self.saveTask()
        }))
        present(alert, animated: true)
    }
}
