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
        self.dismissKey()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupReminderTime() //setups initial reminder time
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Add Task")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Not topView
    let titleHeading = makeHeading(withText: "Title")
    let startDatePicker = makeDatePicker(height: UIScreen.main.bounds.height/7)
    let titleTextField = makeTextField(withPlaceholder: "Title")
    let startDateHeading = makeHeading(withText: "Start Date:")
    let durationHeading = makeHeading(withText: "Duration:")
    let durationPickerView = UIPickerView()
    let reminderHeading = makeHeading(withText: "Reminder:")
    let reminderButton = setValueButton(withPlaceholder: "None")
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
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        deleteButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        deleteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        
        //Not topView
        titleHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/55, paddingLeft: 20)
        titleTextField.centerX(in: view)
        titleTextField.anchor(top: titleHeading.bottomAnchor, paddingTop: 2)
        titleTextField.delegate = self

        
        startDateHeading.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/30, paddingLeft: 20)
        startDatePicker.centerX(in: view)
        startDatePicker.anchor(top: startDateHeading.bottomAnchor)
        
        durationHeading.anchor(top: startDatePicker.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/30, paddingLeft: 20)
        setupDurationPickerView()
        reminderHeading.anchor(top: durationPickerView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/25, paddingLeft: 20)
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        
        saveButton.centerX(in: view)
        saveButton.anchor(top: reminderButton.bottomAnchor, paddingTop: UIScreen.main.bounds.height/18)
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        if let taskIndex = TaskService.shared.getTaskIndex() {
            if let task = TaskService.shared.getTask(atIndex: taskIndex) {
                titleTextField.text = task.title
                startDatePicker.date = task.startDate
                
                let calendar = Calendar.current
                let timeComponents = calendar.dateComponents([.hour, .minute], from: task.endDate)
                let nowComponents = calendar.dateComponents([.hour, .minute], from: startDatePicker.date)
                
                let difference = abs(calendar.dateComponents([.minute], from: nowComponents, to: timeComponents).minute!)
                let hours = difference / 60
                let minutes = difference - (hours * 60)
                durationPickerView.selectRow(hours, inComponent:0, animated: false)
                durationPickerView.selectRow(minutes, inComponent:3, animated: false)
                
                TaskService.shared.setHideReminder(bool: !task.reminder)
                TaskService.shared.setReminderDate(date: task.reminderDate)
                TaskService.shared.setDateOrTime(scIndex: task.dateOrTime)
                let reminderTime: [Int] = [task.reminderTime[0], task.reminderTime[1]]
                TaskService.shared.setReminderTime(reminderTime)
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
    
    func setupReminderTime() {
        reminderButton.isHidden = TaskService.shared.getHideReminder()
        reminderSwitch.isOn = !reminderButton.isHidden
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
    }
    
    //MARK: - Actions
    @objc func saveTask() {
        
        hour = durationPickerView.selectedRow(inComponent: 0)
        minutes = durationPickerView.selectedRow(inComponent: 3)
        let duration = hour*3600 + minutes*60
        var endDate = startDatePicker.date
        endDate.addTimeInterval(TimeInterval(duration))
        
        let task = Task()
        task.title = titleTextField.text ?? ""
        task.startDate = startDatePicker.date
        task.endDate = endDate
        task.dateOrTime = TaskService.shared.getDateOrTime()
        task.reminder = reminderSwitch.isOn
        if task.dateOrTime == 0 {
            let reminderTime = TaskService.shared.getReminderTime()
            task.reminderTime[0] = reminderTime[0]
            task.reminderTime[1] = reminderTime[1]
        } else {
            task.reminderDate = TaskService.shared.getReminderDate()
        }
        
        if !checkForTimeConflict(startTime: task.startDate, endDateTime: task.endDate, check: TaskService.shared.getCheckForTimeConflict()) {
            do {
                try realm.write {
                    if TaskService.shared.getTaskIndex() != nil {
                        if let taskIndex = TaskService.shared.getTaskIndex() {
                            //Updates previous task
                            var taskToUpdate = TaskService.shared.getTask(atIndex: taskIndex)
                            taskToUpdate?.title = task.title
                            taskToUpdate?.startDate = task.startDate
                            taskToUpdate?.endDate = task.endDate
                            taskToUpdate?.dateOrTime = task.dateOrTime
                            taskToUpdate?.reminderDate = task.reminderDate
                            taskToUpdate?.reminder = task.reminder
                            taskToUpdate?.reminderTime[0] = task.reminderTime[0]
                            taskToUpdate?.reminderTime[1] = task.reminderTime[1]
                        }
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
                        realm.add(task, update: .modified)
                    }
                }
            } catch {
                print("Error writing task to realm, \(error.localizedDescription)")
            }
            TaskService.shared.updateTasks()
            scheduleNotification()
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
            TaskService.shared.setHideReminder(bool: false)
            askToSendNotifications()
        } else {
            reminderButton.isHidden = true
            TaskService.shared.setHideReminder(bool: true)
        }
    }
    
    //MARK: - Push notification methods
    @objc func askToSendNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {_,_ in })
    }
    
    @objc func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        var dateComponents = DateComponents()
        let units: Set<Calendar.Component> = [.nanosecond, .second,.minute, .hour, .day, .month, .year]
        
        //If user specified time before a specific date for the reminder
        if TaskService.shared.getDateOrTime() == 0 {
            let reminderTime = TaskService.shared.getReminderTime()
            var comps = Calendar.current.dateComponents(units, from: startDatePicker.date)
            comps.second = 0 //ignores seconds -> reminder happens when the specified minute occurs
            dateComponents = comps
            if let hours = dateComponents.hour, let minutes = dateComponents.minute{
                dateComponents.hour = hours - reminderTime[0]
                dateComponents.minute = minutes - reminderTime[1]

                if reminderTime[0] == 0, reminderTime[1] == 0 {
                   content.body = "Your task starts now"
                } else  {
                    content.body = "Your task will start in \(reminderTime[0]) hour(s) and \(reminderTime[1]) minutes"
                }
            }
        } else {
            var comps = Calendar.current.dateComponents(units, from: TaskService.shared.getReminderDate())
            comps.nanosecond = 0
            comps.second = 0
            dateComponents = comps
            let date = TaskService.shared.formatDate(from: startDatePicker.date)
            content.body = "Your task will start on \(date)"
        }
        
        content.title = titleTextField.text ?? ""
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    //MARK: - Helper methods
    func checkForTimeConflict(startTime: Date, endDateTime: Date, check: Bool) -> Bool{
        
        var addOne = 0
        if TaskService.shared.getTaskIndex() == nil {
            addOne = 1
        }
        //If the user does not care about the time conflict
        if !check { return false }
        
        //1) A previous tasks start time is in between the current tasks start and end times
        let conflictCheck1 = realm.objects(Task.self).filter("startDate > %@ AND startDate < %@", startTime, endDateTime)
        if conflictCheck1.count + addOne > 1 {
            showAlert()
            return true
        }
        
        //2) A previous tasks end time is in between the current tasks start and end times
        let conflictCheck2 = realm.objects(Task.self).filter("endDate > %@ AND endDate < %@", startTime, endDateTime)
        if conflictCheck2.count + addOne > 1 {
            showAlert()
            return true
        }
        
        //3) The current tasks start time is in between a previous taks start and end time
        let conflictCheck3 = realm.objects(Task.self).filter("startDate < %@ AND endDate > %@", startTime, startTime)
        if conflictCheck3.count + addOne > 1 {
            showAlert()
            return true
        }
        
        //4) The current tasks end time is in between a previous taks start and end time
        let conflictCheck4 = realm.objects(Task.self).filter("startDate < %@ AND endDate > %@", endDateTime, endDateTime)
        if conflictCheck4.count + addOne > 1 {
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

extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
