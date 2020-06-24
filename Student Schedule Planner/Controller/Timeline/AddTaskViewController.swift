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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if reminderSwitch.isOn {
            UIView.animate(withDuration: 0.3, animations: {
                self.colorView.frame.origin.y = self.reminderButton.frame.maxY
            })
        }
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Add Task")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Not topView
    let titleHeading = makeHeading(withText: "Title")
    let titleTextField = makeTextField(withPlaceholder: "Title")
    let timePickerView = makeTimePicker()
    let reminderHeading = makeHeading(withText: "Reminder:")
    let reminderButton = setValueButton(withPlaceholder: "None")
    let reminderSwitch = UISwitch()
    let colorHeading = makeHeading(withText: "Color:")
    let saveButton = makeSaveButton()
    let startTimeView = PentagonView()
    let endTimeView = UIView()
    let clockIcon = UIImage(systemName: "clock.fill")
    var clockImage = UIImageView(image: nil)
    let reminderView = makeAnimatedView(height: UIScreen.main.bounds.height/4)
    let colorView = makeAnimatedView(height: UIScreen.main.bounds.height/6)
    let startTime = makeLabel(ofSize: 20, weight: .semibold)
    let endTime = makeLabel(ofSize: 20, weight: .semibold)
    let locationHeading = makeHeading(withText: "Location")
    let locationTextField = makeTextField(withPlaceholder: "Location")
    
    var topAnchorConstaint = NSLayoutConstraint()
    var otherAnchorConstaint = NSLayoutConstraint()
    
    var colorTopAnchorConstaint = NSLayoutConstraint()
    var colorOtherAnchorConstaint = NSLayoutConstraint()
    
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
        clockImage = UIImageView(image: clockIcon!)
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(titleHeading)
        view.addSubview(titleTextField)
        view.addSubview(saveButton)
        view.addSubview(endTimeView)
        view.addSubview(startTimeView)
        view.addSubview(timePickerView)
        view.addSubview(reminderView)
        
        reminderView.addSubview(reminderHeading)
        reminderView.addSubview(reminderButton)
        reminderView.addSubview(reminderSwitch)
        reminderView.addSubview(colorView)

        colorView.addSubview(locationHeading)
        colorView.addSubview(locationTextField)
        colorView.addSubview(colorHeading)
        colorView.addSubview(colorStackView)
        
        colorStackView.addArrangedSubview(red)
        colorStackView.addArrangedSubview(orange)
        colorStackView.addArrangedSubview(yellow)
        colorStackView.addArrangedSubview(green)
        colorStackView.addArrangedSubview(turquoise)
        colorStackView.addArrangedSubview(blue)
        colorStackView.addArrangedSubview(darkBlue)
        colorStackView.addArrangedSubview(purple)
        
        startTimeView.addSubview(clockImage)
        startTimeView.addSubview(startTime)
        
        endTimeView.addSubview(endTime)
        
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
        titleHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/50, paddingLeft: 20)
        titleTextField.centerX(in: view)
        titleTextField.anchor(top: titleHeading.bottomAnchor, paddingTop: 2)
        titleTextField.delegate = self
        
        startTimeView.setDimensions(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/15)
        startTimeView.anchor(top: titleTextField.bottomAnchor, left: titleHeading.leftAnchor, paddingTop: UIScreen.main.bounds.height/50)
        let startTap = UITapGestureRecognizer(target: self, action: #selector(startDateViewTapped))
        startTimeView.addGestureRecognizer(startTap)
        clockImage.anchor(left: startTimeView.leftAnchor, paddingLeft: 25)
        clockImage.centerY(in: startTimeView)
        clockImage.tintColor = .darkGray
        endTimeView.setDimensions(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/15)
        endTimeView.anchor(top: titleTextField.bottomAnchor, right: view.rightAnchor, paddingTop: UIScreen.main.bounds.height/50, paddingRight: 20)
        endTimeView.layer.borderColor = UIColor.silver.cgColor
        endTimeView.layer.borderWidth = 1
        endTimeView.backgroundColor = .backgroundColor
        let endTap = UITapGestureRecognizer(target: self, action: #selector(endDateViewTapped))
        endTimeView.addGestureRecognizer(endTap)
        setupDurationPickerView()
        
        topAnchorConstaint = reminderView.topAnchor.constraint(equalTo: startTimeView.bottomAnchor)
        otherAnchorConstaint = reminderView.topAnchor.constraint(equalTo: timePickerView.bottomAnchor)
        
        colorTopAnchorConstaint = colorView.topAnchor.constraint(equalTo: reminderSwitch.bottomAnchor)
        colorOtherAnchorConstaint = colorView.topAnchor.constraint(equalTo: reminderButton.bottomAnchor)
        colorTopAnchorConstaint.isActive = true
        
        colorView.topAnchor.constraint(equalTo: reminderSwitch.bottomAnchor).isActive = true
        colorView.centerX(in: reminderView)
        
        reminderView.topAnchor.constraint(equalTo: startTimeView.bottomAnchor)
        reminderView.anchor(left: view.leftAnchor, paddingLeft: 20)
        reminderHeading.anchor(top: reminderView.topAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/50, paddingLeft: 20)
        
        topAnchorConstaint.isActive = true
        
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        
        locationHeading.anchor(top: colorView.topAnchor, left: reminderButton.leftAnchor, paddingTop: UIScreen.main.bounds.height/50)
        locationTextField.anchor(top: locationHeading.bottomAnchor, left: reminderButton.leftAnchor, paddingTop: 5)
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: UIScreen.main.bounds.height/15)
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        colorHeading.anchor(top: locationTextField.bottomAnchor, left: reminderHeading.leftAnchor, paddingTop: UIScreen.main.bounds.height/50)
        colorStackView.anchor(top: colorHeading.bottomAnchor, left: colorHeading.leftAnchor, paddingTop: 5)
        
        startTime.centerX(in: startTimeView)
        startTime.centerY(in: startTimeView)
        
        endTime.centerX(in: endTimeView)
        endTime.centerY(in: endTimeView)
        
        startTime.text = "\(formatTime(from: Date()))"
        endTime.text = "\(formatTime(from: Date().addingTimeInterval(3600)))"
        
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
                
                let calendar = Calendar.current
                let timeComponents = calendar.dateComponents([.hour, .minute], from: task.endDate)
                //                let nowComponents = calendar.dateComponents([.hour, .minute], from: startDatePicker.date)
                
                //                let difference = abs(calendar.dateComponents([.minute], from: nowComponents, to: timeComponents).minute!)
                //                let hours = difference / 60
                //                let minutes = difference - (hours * 60)
                //                durationPickerView.selectRow(hours, inComponent:0, animated: false)
                //                durationPickerView.selectRow(minutes, inComponent:3, animated: false)
                
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
        timePickerView.anchor(top: startTimeView.bottomAnchor)
        timePickerView.centerX(in: view)
        timePickerView.setDimensions(width: UIScreen.main.bounds.width - 100)
        timePickerView.backgroundColor = .backgroundColor
        timePickerView.addTarget(self, action: #selector(timePickerDateChanged), for: .valueChanged)
    }
    
    func setupReminderTime() {
        reminderButton.isHidden = TaskService.shared.getHideReminder()
        reminderSwitch.isOn = !reminderButton.isHidden
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
    }
    
    //MARK: - Actions
    @objc func timePickerDateChanged() {
        topAnchorConstaint.isActive = false
        otherAnchorConstaint.isActive = true
        
        if startTimeView.color == UIColor.mainBlue {
            TaskService.shared.setStartTime(time: timePickerView.date)
            startTime.text = "\(formatTime(from: timePickerView.date))"
        } else {
            TaskService.shared.setEndTime(time: timePickerView.date)
            endTime.text  = "\(formatTime(from: timePickerView.date))"
        }
    }
    
    @objc func startDateViewTapped() {
        if startTimeView.color != UIColor.mainBlue {
            timePickerView.date = TaskService.shared.getStartTime()
            startTimeView.color = .mainBlue
            startTimeView.borderColor = .clear
            clockImage.tintColor = .white
            startTime.textColor = .backgroundColor
            endTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.reminderView.frame.origin.y = self.timePickerView.frame.maxY
            })
        } else {
            startTimeView.color = .clouds
            startTimeView.borderColor = .silver
            clockImage.tintColor = .darkGray
            startTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.reminderView.frame.origin.y = self.startTimeView.frame.maxY
            })
        }
        endTimeView.backgroundColor = .backgroundColor
        endTimeView.layer.borderColor = UIColor.silver.cgColor
    }
    
    @objc func endDateViewTapped() {
        if endTimeView.backgroundColor != UIColor.mainBlue {
            timePickerView.date = TaskService.shared.getEndTime()
            endTimeView.backgroundColor = .mainBlue
            endTimeView.layer.borderColor = UIColor.clear.cgColor
            endTime.textColor = .backgroundColor
            startTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.reminderView.frame.origin.y = self.timePickerView.frame.maxY
            })
        } else {
            endTimeView.backgroundColor = .backgroundColor
            endTimeView.layer.borderColor = UIColor.silver.cgColor
            endTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.reminderView.frame.origin.y = self.startTimeView.frame.maxY
            })
        }
        startTimeView.color = .clouds
        startTimeView.borderColor = .silver
        clockImage.tintColor = .darkGray
    }
    
    @objc func saveTask() {
        //        hour = durationPickerView.selectedRow(inComponent: 0)
        //        minutes = durationPickerView.selectedRow(inComponent: 3)
        //  let duration = hour*3600 + minutes*60
        //        var endDate = startDatePicker.date
        //        endDate.addTimeInterval(TimeInterval(duration))
        
        let task = Task()
        task.title = titleTextField.text ?? ""
        task.startDate = TaskService.shared.getStartTime()
        task.endDate = TaskService.shared.getEndTime()
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
                        let taskToUpdate = TaskService.shared.getTask(atIndex: taskIndex)
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
            UIView.animate(withDuration: 0.3, animations: {
                self.colorView.frame.origin.y = self.reminderButton.frame.maxY
            })
        } else {
            reminderButton.isHidden = true
            TaskService.shared.setHideReminder(bool: true)
            UIView.animate(withDuration: 0.3, animations: {
                self.colorView.frame.origin.y = self.reminderSwitch.frame.maxY
            })
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
        print("OKOK")
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
