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
        CourseService.shared.setColor(int: 0)
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Add Task")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Not topView
    let titleHeading = makeHeading(withText: "Title")
    let startDatePicker = makeDateAndTimePicker(height: UIScreen.main.bounds.height/7)
    let titleTextField = makeTextField(withPlaceholder: "Title")
    let startDateHeading = makeHeading(withText: "Start Date:")
    let durationHeading = makeHeading(withText: "Duration:")
    let durationPickerView = UIPickerView()
    let reminderHeading = makeHeading(withText: "Reminder:")
    let reminderButton = setValueButton(withPlaceholder: "None")
    let reminderSwitch = UISwitch()
    let colorHeading = makeHeading(withText: "Color:")
    let saveButton = makeSaveButton()
    
    //Color Buttons
    let red = makeColorButton(ofColor: .alizarin)
    let orange = makeColorButton(ofColor: .carrot)
    let yellow = makeColorButton(ofColor: .sunflower)
    let green = makeColorButton(ofColor: .emerald)
    let turquoise = makeColorButton(ofColor: .turquoise)
    let blue = makeColorButton(ofColor: .riverBlue)
    let darkBlue = makeColorButton(ofColor: .midnightBlue)
    let purple = makeColorButton(ofColor: .amethyst)
    let colorStackView = makeStackView(withOrientation: .horizontal, spacing: 3)

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
        view.addSubview(colorHeading)
        view.addSubview(colorStackView)
        
        
        colorStackView.addArrangedSubview(red)
        colorStackView.addArrangedSubview(orange)
        colorStackView.addArrangedSubview(yellow)
        colorStackView.addArrangedSubview(green)
        colorStackView.addArrangedSubview(turquoise)
        colorStackView.addArrangedSubview(blue)
        colorStackView.addArrangedSubview(darkBlue)
        colorStackView.addArrangedSubview(purple)
        
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
        saveButton.anchor(top: colorStackView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/30)
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        colorHeading.anchor(top: reminderButton.bottomAnchor, left: reminderHeading.leftAnchor, paddingTop: UIScreen.main.bounds.height/80)
        colorStackView.anchor(top: colorHeading.bottomAnchor, left: colorHeading.leftAnchor, paddingTop: 5)
        
        red.tag = 0
        orange.tag = 1
        yellow.tag = 2
        green.tag = 3
        turquoise.tag = 4
        blue.tag = 5
        darkBlue.tag = 6
        purple.tag = 7
        
        red.alpha = 0.3
        red.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        orange.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        yellow.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        green.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        turquoise.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        blue.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        darkBlue.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        purple.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        
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
                CourseService.shared.setColor(int: task.color)
                
                switch task.color {
                case 0:
                    colorButtonPressed(button: red)
                case 1:
                    colorButtonPressed(button: orange)
                case 2:
                    colorButtonPressed(button: yellow)
                case 3:
                    colorButtonPressed(button: green)
                case 4:
                    colorButtonPressed(button: turquoise)
                case 5:
                    colorButtonPressed(button: blue)
                case 6:
                    colorButtonPressed(button: darkBlue)
                case 7:
                    colorButtonPressed(button: purple)
                default:
                    break
                }
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
        task.color = CourseService.shared.getColor()
        
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
                            taskToUpdate?.color = task.color
                    } else {
//                        let dateOfTask = Calendar.current.startOfDay(for: startDatePicker.date)
//                        let endOfDay: Date = {
//                            let components = DateComponents(day: 1, second: -1)
//                            return Calendar.current.date(byAdding: components, to: dateOfTask)!
//                        }()
                        
                        //Check if there is already a date object for the day of the task
//                        let day = realm.objects(Day.self).filter("date BETWEEN %@", [dateOfTask, endOfDay]).first
//                        if let day = day {
//                            day.tasks.append(task)
//                        } else {
//                            let newDay = Day()
//                            newDay.tasks.append(task)
//                            realm.add(newDay)
//                        }
                        realm.add(task, update: .modified)
                    }
                }
            } catch {
                print("Error writing task to realm, \(error.localizedDescription)")
            }
            TaskService.shared.updateTasks()
            TaskService.shared.scheduleNotification(forTask: task)
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
        let vc = SetTaskReminderViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @objc func reminderSwitchToggled() {
        if reminderSwitch.isOn {
            reminderButton.isHidden = false
            TaskService.shared.setHideReminder(bool: false)
            TaskService.shared.askToSendNotifications()
        } else {
            reminderButton.isHidden = true
            TaskService.shared.setHideReminder(bool: true)
        }
    }
    
    @objc func colorButtonPressed(button: UIButton) {
        red.alpha = 1
        orange.alpha = 1
        yellow.alpha = 1
        green.alpha = 1
        turquoise.alpha = 1
        blue.alpha = 1
        darkBlue.alpha = 1
        purple.alpha = 1
        
        button.alpha = 0.3
        CourseService.shared.setColor(int: button.tag)
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
