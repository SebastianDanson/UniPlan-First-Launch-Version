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

/*
 * This VC allows the user to add, edit, or delete a Task
 */
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
        setupReminderTime() //sets up initial reminder time
        colorRectangle.backgroundColor = TaskService.shared.getColor()
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
    let colorRectangle = UIButton()
    
    //Not topView
    let titleTextField = makeTextField(withPlaceholder: "Title", height: 50 )
    let locationTextField = makeTextField(withPlaceholder: "Location", height: 45)
    let locationView = makeAnimatedView()
    
    let dateButton = makeButtonWithImage(withPlaceholder: "Today", imageName: "calendar")
    
    let startTimeView = PentagonView()
    let endTimeView = UIView()
    
    let timePickerView = makeTimePicker(withHeight: UIScreen.main.bounds.height/6)
    let datePickerView = makeDatePicker(withHeight: UIScreen.main.bounds.height / 6)
    
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
    
    //Top anchors for reminderView
    var locationTopAnchorConstaint = NSLayoutConstraint()
    var locationOtherAnchorConstaint = NSLayoutConstraint()
        
    //Top anchors for locationView
    var reminderTopAnchorConstaint = NSLayoutConstraint()
    var reminderOtherAnchorConstaint = NSLayoutConstraint()
    
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
        colorView.addSubview(colorRectangle)
        
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
        titleTextField.font = UIFont.systemFont(ofSize: 22, weight: .bold)
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
        datePickerView.minimumDate = Date()
        
        colorView.topAnchor.constraint(equalTo: reminderSwitch.bottomAnchor).isActive = true
        colorView.setDimensions(height: 100)
        colorView.centerX(in: reminderView)
        
        colorRectangle.backgroundColor = TaskService.shared.getColor()
        colorRectangle.setDimensions(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/18)
        colorRectangle.layer.cornerRadius = 6
        colorRectangle.anchor(top: colorHeading.bottomAnchor, left: reminderHeading.leftAnchor, paddingTop: 5)
        colorRectangle.addTarget(self, action: #selector(colorRectanglePressed), for: .touchUpInside)
        
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
        
        locationTopAnchorConstaint = locationView.topAnchor.constraint(equalTo: startTimeView.bottomAnchor)
        locationOtherAnchorConstaint = locationView.topAnchor.constraint(equalTo: timePickerView.bottomAnchor)
        locationTopAnchorConstaint.isActive = true
        
        reminderTopAnchorConstaint = reminderView.topAnchor.constraint(equalTo: dateButton.bottomAnchor)
        reminderOtherAnchorConstaint = reminderView.topAnchor.constraint(equalTo: datePickerView.bottomAnchor)
        reminderTopAnchorConstaint.isActive = true
        
        locationTextField.anchor(top: reminderView.topAnchor,
                                 left: reminderButton.leftAnchor,
                                 paddingTop: 10)
        
        locationTextField.setIcon(UIImage(named: "location")!)
        locationTextField.delegate = self
        colorHeading.anchor(top: colorView.topAnchor,
                            left: reminderHeading.leftAnchor,
                            paddingTop: 5)
        
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: UIScreen.main.bounds.height/25)
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
        
        //If a previous task was selected
        if let taskIndex = TaskService.shared.getTaskIndex() {
            if let task = TaskService.shared.getTask(atIndex: taskIndex) {
                titleTextField.text = task.title
                
                TaskService.shared.setHideReminder(bool: !task.reminder)
                TaskService.shared.setReminderDate(date: task.reminderDate)
                TaskService.shared.setDateOrTime(scIndex: task.dateOrTime)
                let reminderTime: [Int] = [task.reminderTime[0], task.reminderTime[1]]
                TaskService.shared.setReminderTime(reminderTime)
                locationTextField.text = task.location
                startTime.text = formatTime(from: task.startDate)
                endTime.text = formatTime(from: task.endDate)
                TaskService.shared.setStartTime(time: task.startDate)
                TaskService.shared.setEndTime(time: task.endDate)
                titleLabel.text = "Edit Task"
            }
        }
    }
    
    func setupTimePickerView() {
        timePickerView.anchor(top: startTimeView.bottomAnchor)
        timePickerView.centerX(in: view)
        timePickerView.setDimensions(width: UIScreen.main.bounds.width - 100)
        timePickerView.backgroundColor = .backgroundColor
        timePickerView.addTarget(self, action: #selector(timePickerDateChanged), for: .valueChanged)
        timePickerView.minimumDate = Date()
    }
    
    func setupReminderTime() {
        reminderButton.isHidden = TaskService.shared.getHideReminder()
        reminderSwitch.isOn = !reminderButton.isHidden
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
    }
    
    //MARK: - Actions
    @objc func colorRectanglePressed() {
        let vc = ColorsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func timePickerDateChanged() {
        locationTopAnchorConstaint.isActive = false
        locationOtherAnchorConstaint.isActive = true
        
        if startTimeView.color == UIColor.mainBlue {
            TaskService.shared.setStartTime(time: timePickerView.date)
            startTime.text = "\(formatTime(from: timePickerView.date))"
            if TaskService.shared.getStartTime() > TaskService.shared.getEndTime() {
                TaskService.shared.setEndTime(time: timePickerView.date)
                endTime.text = "\(formatTime(from: timePickerView.date))"
            }
        } else {
            TaskService.shared.setEndTime(time: timePickerView.date)
            endTime.text  = "\(formatTime(from: timePickerView.date))"
        }
    }
    
    @objc func datePickerChanged() {
        locationTopAnchorConstaint.isActive = true
        locationOtherAnchorConstaint.isActive = false
        dateButton.setTitle("\(formatDate(from: datePickerView.date))", for: .normal)
    }
    
    @objc func dateButtonTapped() {
       resetTimeViews()
        
        //This asyncAfter fixed a bug where the animation would glitch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001){
            
            if self.reminderTopAnchorConstaint.isActive {
                self.reminderTopAnchorConstaint.isActive = false
                self.reminderOtherAnchorConstaint.isActive = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.reminderView.frame.origin.y = self.datePickerView.frame.maxY
                })
            } else {
                self.reminderTopAnchorConstaint.isActive = true
                self.reminderOtherAnchorConstaint.isActive = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.reminderView.frame.origin.y = self.dateButton.frame.maxY
                })
              
            }
        }
        self.locationTopAnchorConstaint.isActive = true
        self.locationOtherAnchorConstaint.isActive = false
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
            timePickerView.minimumDate = Date()
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.timePickerView.frame.maxY
            })
            self.locationTopAnchorConstaint.isActive = false
            self.locationOtherAnchorConstaint.isActive = true
        } else {
            startTimeView.color = .clouds
            startTimeView.borderColor = .silver
            clockImage.tintColor = .darkGray
            startTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.startTimeView.frame.maxY
            })
            self.locationTopAnchorConstaint.isActive = true
            self.locationOtherAnchorConstaint.isActive = false
        }
        endTimeView.backgroundColor = .backgroundColor
        endTimeView.layer.borderColor = UIColor.silver.cgColor
        self.reminderTopAnchorConstaint.isActive = true
        self.reminderOtherAnchorConstaint.isActive = false
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
            timePickerView.minimumDate = TaskService.shared.getStartTime()
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.timePickerView.frame.maxY
            })
            self.locationTopAnchorConstaint.isActive = false
            self.locationOtherAnchorConstaint.isActive = true
        } else {
            endTimeView.backgroundColor = .backgroundColor
            endTimeView.layer.borderColor = UIColor.silver.cgColor
            endTime.textColor = .darkBlue
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.startTimeView.frame.maxY
            })
            self.locationTopAnchorConstaint.isActive = true
            self.locationOtherAnchorConstaint.isActive = false
        }
        startTimeView.color = .clouds
        startTimeView.borderColor = .silver
        clockImage.tintColor = .darkGray
        self.reminderTopAnchorConstaint.isActive = true
        self.reminderOtherAnchorConstaint.isActive = false
    }
    
    func resetTimeViews() {
        if locationView.frame.origin.y == timePickerView.frame.maxY {
            UIView.animate(withDuration: 0.3, animations: {
                self.locationView.frame.origin.y = self.startTimeView.frame.maxY
            })
            startTimeView.color = .clouds
            endTimeView.backgroundColor = .backgroundColor
            startTime.textColor = .darkBlue
            endTime.textColor = .darkBlue
            clockImage.tintColor = .darkGray
            endTimeView.layer.borderColor = UIColor.silver.cgColor
            startTimeView.borderColor = .silver
            
            locationTopAnchorConstaint.isActive = true
            locationOtherAnchorConstaint.isActive = false
        }
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
        task.location = locationTextField.text ?? ""
        
        let rgb = TaskService.shared.getColor().components
        
        task.color[0] = Double(rgb.red)
        task.color[1] = Double(rgb.green)
        task.color[2] = Double(rgb.blue)
        
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
                        
                        taskToUpdate?.color[0] = task.color[0]
                        taskToUpdate?.color[1] = task.color[1]
                        taskToUpdate?.color[2] = task.color[2]
                        
                        taskToUpdate?.location = task.location
                        if task.reminder, let taskToUpdate = taskToUpdate {
                            TaskService.shared.scheduleNotification(forTask: taskToUpdate)
                        } else if let taskToUpdate = taskToUpdate {
                            TaskService.shared.deleteNotification(forTask: taskToUpdate)
                        }
                    } else {
                        realm.add(task, update: .modified)
                        if task.reminder {
                            TaskService.shared.scheduleNotification(forTask: task)
                        }
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
                        
                        switch taskToDelete.type {
                        case "assignment":
                            let assignmentToDelete = realm.objects(Assignment.self).filter("id == %@", taskToDelete.summativeId).first
                            if let assignmentToDelete = assignmentToDelete {
                                realm.delete(assignmentToDelete)
                            }
                        case "quiz":
                            let quizToDelete = realm.objects(Quiz.self).filter("id == %@", taskToDelete.summativeId).first
                            if let quizToDelete = quizToDelete {
                                realm.delete(quizToDelete)
                            }
                        case "exam":
                            let examToDelete = realm.objects(Exam.self).filter("id == %@", taskToDelete.summativeId).first
                            if let examToDelete = examToDelete {
                                realm.delete(examToDelete)
                            }
                        default:
                            break
                        }
                        TaskService.shared.deleteNotification(forTask: taskToDelete)
                        self.realm.delete(taskToDelete)
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
