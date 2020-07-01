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
        //If the user edits a task that has a reminder
        if reminderSwitch.isOn {
            //displays reminder Button
            UIView.animate(withDuration: 0.3, animations: {
                self.colorView.frame.origin.y = self.reminderButton.frame.maxY
            })
        }
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
    let titleLabel = makeTitleLabel(withText: "Add Task")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Not topView
    let titleTextField = makeTextField(withPlaceholder: "Title", height: 50 )
    let locationTextField = makeTextField(withPlaceholder: "Location", height: 45)
    let locationView = makeAnimatedView()
    
    let dateButton = setImageButton(withPlaceholder: "Today", imageName: "calendar")
    
    let startTimeView = PentagonView()
    let endTimeView = UIView()
    let timePickerView = makeTimePicker()
    let datePickerView = makeDatePicker()
    let startTime = makeLabel(ofSize: 20, weight: .semibold)
    let endTime = makeLabel(ofSize: 20, weight: .semibold)
    
    let reminderHeading = makeHeading(withText: "Reminder:")
    let reminderButton = setValueButton(withPlaceholder: "None", height: 45)
    let reminderSwitch = UISwitch()
    let reminderView = makeAnimatedView()
    
    let colorHeading = makeHeading(withText: "Color:")
    let colorView = makeAnimatedView()
    
    let saveButton = makeSaveButton()
    
    let clockIcon = UIImage(systemName: "clock.fill")
    var clockImage = UIImageView(image: nil)
    
    var reminderTopAnchorConstaint = NSLayoutConstraint()
    var reminderOtherAnchorConstaint = NSLayoutConstraint()
    
    var colorTopAnchorConstaint = NSLayoutConstraint()
    var colorOtherAnchorConstaint = NSLayoutConstraint()
    
    var locationTopAnchorConstaint = NSLayoutConstraint()
    var locationOtherAnchorConstaint = NSLayoutConstraint()
    
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
        view.addSubview(titleTextField)
        view.addSubview(endTimeView)
        view.addSubview(startTimeView)
        view.addSubview(timePickerView)
        view.addSubview(locationView)
        view.addSubview(saveButton)
        
        locationView.addSubview(dateButton)
        locationView.addSubview(datePickerView)
        locationView.addSubview(reminderView)
        
        
        reminderView.addSubview(locationTextField)
        reminderView.addSubview(reminderHeading)
        reminderView.addSubview(reminderButton)
        reminderView.addSubview(reminderSwitch)
        reminderView.addSubview(colorView)
        
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
        titleTextField.centerX(in: view)
        titleTextField.anchor(top: topView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/50)
        titleTextField.delegate = self
        titleTextField.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleTextField.layer.borderWidth = 5
        
        let startTap = UITapGestureRecognizer(target: self, action: #selector(startDateViewTapped))
        startTimeView.setDimensions(width: UIScreen.main.bounds.width/2,
                                    height: UIScreen.main.bounds.height/15)
        startTimeView.addGestureRecognizer(startTap)
        startTimeView.anchor(top: titleTextField.bottomAnchor,
                             left: titleTextField.leftAnchor,
                             paddingTop: UIScreen.main.bounds.height/50)
        
        clockImage.anchor(left: startTimeView.leftAnchor, paddingLeft: 25)
        clockImage.centerY(in: startTimeView)
        clockImage.tintColor = .darkGray
        
        let endTap = UITapGestureRecognizer(target: self, action: #selector(endDateViewTapped))
        endTimeView.addGestureRecognizer(endTap)
        endTimeView.layer.borderColor = UIColor.silver.cgColor
        endTimeView.layer.borderWidth = 1
        endTimeView.backgroundColor = .backgroundColor
        endTimeView.setDimensions(width: UIScreen.main.bounds.width/2,
                                  height: UIScreen.main.bounds.height/15)
        
        endTimeView.anchor(top: titleTextField.bottomAnchor,
                           right: view.rightAnchor,
                           paddingTop: UIScreen.main.bounds.height/50,
                           paddingRight: 20)
        
        startTime.centerX(in: startTimeView)
        startTime.centerY(in: startTimeView)
        
        endTime.centerX(in: endTimeView)
        endTime.centerY(in: endTimeView)
        
        dateButton.anchor(top: locationView.topAnchor,
                          left: titleTextField.leftAnchor,
                          paddingTop: UIScreen.main.bounds.height/50)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        
        datePickerView.anchor(top: dateButton.bottomAnchor)
        datePickerView.centerX(in: view)
        datePickerView.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        colorTopAnchorConstaint = colorView.topAnchor.constraint(equalTo: reminderSwitch.bottomAnchor)
        colorOtherAnchorConstaint = colorView.topAnchor.constraint(equalTo: reminderButton.bottomAnchor)
        colorTopAnchorConstaint.isActive = true
        
        colorView.topAnchor.constraint(equalTo: reminderSwitch.bottomAnchor).isActive = true
        colorView.setDimensions(height: 100)
        colorView.centerX(in: reminderView)
        
        reminderView.topAnchor.constraint(equalTo: dateButton.bottomAnchor).isActive = true
        reminderView.anchor(left: view.leftAnchor, paddingLeft: 20)
        reminderView.setDimensions(height: 275)
        reminderHeading.anchor(top: locationTextField.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/50, paddingLeft: 20)
        
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        reminderSwitch.isOn = !reminderButton.isHidden
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        reminderButton.isHidden = TaskService.shared.getHideReminder()
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
        
        locationView.anchor(left: reminderButton.leftAnchor,
                            bottom: saveButton.topAnchor)
        
        reminderTopAnchorConstaint = locationView.topAnchor.constraint(equalTo: startTimeView.bottomAnchor)
        reminderOtherAnchorConstaint = locationView.topAnchor.constraint(equalTo: timePickerView.bottomAnchor)
        reminderTopAnchorConstaint.isActive = true
        
        locationTextField.anchor(top: reminderView.topAnchor,
                                 left: reminderButton.leftAnchor,
                                 paddingTop: 10)
        
        locationTextField.setIcon(UIImage(named: "location")!)
        locationTextField.delegate = self
        colorHeading.anchor(top: colorView.topAnchor,
                            left: reminderHeading.leftAnchor,
                            paddingTop: UIScreen.main.bounds.height/50)
        
        colorStackView.anchor(top: colorHeading.bottomAnchor,
                              left: colorHeading.leftAnchor,
                              paddingTop: 5)
        
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: UIScreen.main.bounds.height/15)
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        setupTimePickerView()
        
        startTime.text = "\(formatTime(from: Date()))"
        endTime.text = "\(formatTime(from: Date().addingTimeInterval(3600)))"
        TaskService.shared.setStartTime(time: Date())
        TaskService.shared.setEndTime(time: Date().addingTimeInterval(3600))
        
        let selectedDay = Calendar.current.dateComponents([.day], from: TaskService.shared.getDateSelected())
        let today = Calendar.current.dateComponents([.day], from: Date())
        if selectedDay != today  {
            dateButton.setTitle(formatDate(from: TaskService.shared.getDateSelected()), for: .normal)
        }
        
        datePickerView.date = TaskService.shared.getDateSelected()
        
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
                
                TaskService.shared.setHideReminder(bool: !task.reminder)
                TaskService.shared.setReminderDate(date: task.reminderDate)
                TaskService.shared.setDateOrTime(scIndex: task.dateOrTime)
                let reminderTime: [Int] = [task.reminderTime[0], task.reminderTime[1]]
                TaskService.shared.setReminderTime(reminderTime)
                CourseService.shared.setColor(int: task.color)
                locationTextField.text = task.location
                startTime.text = formatTime(from: task.startDate)
                endTime.text = formatTime(from: task.endDate)
                TaskService.shared.setStartTime(time: task.startDate)
                TaskService.shared.setEndTime(time: task.endDate)
                titleLabel.text = "Edit Task"
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
    
    func setupTimePickerView() {
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
        reminderTopAnchorConstaint.isActive = false
        reminderOtherAnchorConstaint.isActive = true
        
        if startTimeView.color == UIColor.mainBlue {
            TaskService.shared.setStartTime(time: timePickerView.date)
            startTime.text = "\(formatTime(from: timePickerView.date))"
        } else {
            TaskService.shared.setEndTime(time: timePickerView.date)
            endTime.text  = "\(formatTime(from: timePickerView.date))"
        }
    }
    
    @objc func datePickerChanged() {
        dateButton.setTitle("\(formatDate(from: datePickerView.date))", for: .normal)
    }
    
    @objc func dateButtonTapped() {
        if self.startTimeView.color == UIColor.mainBlue {
            self.startDateViewTapped()
        } else if self.endTimeView.backgroundColor == UIColor.mainBlue {
            self.endDateViewTapped()
        }
        
        if reminderView.frame.origin.y == dateButton.frame.maxY {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.reminderView.frame.origin.y = self.datePickerView.frame.maxY
                })
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.reminderView.frame.origin.y = self.dateButton.frame.maxY
                })
            }
        }
    }
    
    @objc func startDateViewTapped() {
        if reminderView.frame.origin.y == datePickerView.frame.maxY {
            UIView.animate(withDuration: 0.3, animations: {
                self.reminderView.frame.origin.y = self.dateButton.frame.maxY
            })
        }
        
        if startTimeView.color != UIColor.mainBlue {
            timePickerView.date = TaskService.shared.getStartTime()
            startTimeView.color = .mainBlue
            startTimeView.borderColor = .clear
            clockImage.tintColor = .white
            startTime.textColor = .backgroundColor
            endTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.timePickerView.frame.maxY
            })
        } else {
            startTimeView.color = .clouds
            startTimeView.borderColor = .silver
            clockImage.tintColor = .darkGray
            startTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.startTimeView.frame.maxY
            })
        }
        endTimeView.backgroundColor = .backgroundColor
        endTimeView.layer.borderColor = UIColor.silver.cgColor
    }
    
    @objc func endDateViewTapped() {
        if reminderView.frame.origin.y == datePickerView.frame.maxY {
            UIView.animate(withDuration: 0.3, animations: {
                self.reminderView.frame.origin.y = self.dateButton.frame.maxY
            })
        }
        
        if endTimeView.backgroundColor != UIColor.mainBlue {
            timePickerView.date = TaskService.shared.getEndTime()
            endTimeView.backgroundColor = .mainBlue
            endTimeView.layer.borderColor = UIColor.clear.cgColor
            endTime.textColor = .backgroundColor
            startTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.timePickerView.frame.maxY
            })
        } else {
            endTimeView.backgroundColor = .backgroundColor
            endTimeView.layer.borderColor = UIColor.silver.cgColor
            endTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.startTimeView.frame.maxY
            })
        }
        startTimeView.color = .clouds
        startTimeView.borderColor = .silver
        clockImage.tintColor = .darkGray
    }
    
    @objc func saveTask() {
        let task = Task()
        task.title = titleTextField.text ?? ""
        
        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: TaskService.shared.getStartTime())
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: TaskService.shared.getEndTime())
        let date = Calendar.current.startOfDay(for: datePickerView.date)
        
        task.startDate = date.addingTimeInterval(TimeInterval(startComponents.hour! * 3600 + startComponents.minute! * 60))
        task.endDate = date.addingTimeInterval(TimeInterval(endComponents.hour! * 3600 + endComponents.minute! * 60))
        task.dateOrTime = TaskService.shared.getDateOrTime()
        task.reminder = reminderSwitch.isOn
        task.color = CourseService.shared.getColor()
        task.location = locationTextField.text ?? ""
        
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
                        taskToUpdate?.location = task.location
                    } else {
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

//MARK: - TextField Delegate
extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
