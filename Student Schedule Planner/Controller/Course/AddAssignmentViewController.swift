//
//  AddAssignmentViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-16.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class AddAssignmentViewController: UIViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        SingleClassService.shared.setReminder(false)
        setupViews()
        self.dismissKey()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if SingleClassService.shared.getReminder() {
            reminderSwitch.isOn = true
            reminderSwitchToggled()
        }
    }
    
    //MARK: - Properties
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "Add Assignment")
    let backButton = makeBackButton()
    let saveButton = makeSaveButton()
    let titleTextField = makeTextField(withPlaceholder: "Title", height: 50)
    let dateHeading = makeHeading(withText: "Due Date:")
    let datePicker = makeDateAndTimePicker(height: UIScreen.main.bounds.height/5)
    let reminderHeading = makeHeading(withText: "Reminder")
    let reminderSwitch = UISwitch()
    let reminderButton = setValueButton(withPlaceholder: "When Task Starts", height: 45)
    let hideReminderView = makeAnimatedView()
    
    //MARK: - UI Setup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(saveButton)
        view.addSubview(titleTextField)
        view.addSubview(dateHeading)
        view.addSubview(datePicker)
        view.addSubview(reminderButton)
        view.addSubview(reminderSwitch)
        view.addSubview(reminderHeading)
        view.addSubview(hideReminderView)
        
        //topView
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        //Not topView
        titleTextField.layer.borderWidth = 5
        titleTextField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleTextField.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        dateHeading.anchor(top: titleTextField.bottomAnchor, left: titleTextField.leftAnchor, paddingTop: 25)
        
        datePicker.anchor(top: dateHeading.bottomAnchor)
        datePicker.centerX(in: view)
        
        reminderHeading.anchor(top: datePicker.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/25, paddingLeft: 20)
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        
        hideReminderView.anchor(top: reminderSwitch.bottomAnchor)
        hideReminderView.centerX(in: view)
        hideReminderView.setDimensions(height: 55)
        
        saveButton.anchor(top: reminderButton.bottomAnchor, paddingTop: UIScreen.main.bounds.height/10)
        saveButton.centerX(in: view)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        if let assignmentIndex = AssignmentService.shared.getAssignmentIndex(){
            if let assignment = CourseService.shared.getAssignment(atIndex: assignmentIndex) {
                titleTextField.text = assignment.title
                datePicker.date = assignment.dueDate
                reminderSwitch.isOn = assignment.reminder
                
                if assignment.reminder {
                    reminderButton.setTitle(TaskService.shared.setupReminderString(dateOrTime: assignment.dateOrTime, reminderTime: [assignment.reminderTime[0],assignment.reminderTime[1]], reminderDate: assignment.reminderDate), for: .normal)
                        SingleClassService.shared.setReminder(true)
                }                
            }
        }
    }
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        var assignment = Assignment()
        assignment.title = titleTextField.text ?? "Untitled"
        assignment.dueDate = datePicker.date
        assignment.dateOrTime = TaskService.shared.getDateOrTime()
        assignment.reminder = reminderSwitch.isOn
        
        if assignment.dateOrTime == 0 {
            let reminderTime = TaskService.shared.getReminderTime()
            assignment.reminderTime[0] = reminderTime[0]
            assignment.reminderTime[1] = reminderTime[1]
        } else {
            assignment.reminderDate = TaskService.shared.getReminderDate()
        }
        
        do {
            try realm.write {
                if let assignmentIndex = AssignmentService.shared.getAssignmentIndex() {
                    var assignmentToUpdate = CourseService.shared.getAssignment(atIndex: assignmentIndex)
                    assignmentToUpdate?.title = assignment.title
                    assignmentToUpdate?.dueDate = assignment.dueDate
                    assignmentToUpdate?.reminderTime[0] = assignment.reminderTime[0]
                    assignmentToUpdate?.reminderTime[1] = assignment.reminderTime[1]
                    assignmentToUpdate?.reminderDate = assignment.reminderDate
                    assignmentToUpdate?.reminder = assignment.reminder
                    assignmentToUpdate?.dateOrTime = assignment.dateOrTime
                } else {
                    realm.add(assignment, update: .modified)
                    if let course = AllCoursesService.shared.getSelectedCourse() {
                        course.assignments.append(assignment)
                    }
                }
            }
        } catch {
            print("Error writing Class to realm \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reminderButtonPressed() {
        let vc = SetTaskReminderViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @objc func reminderSwitchToggled() {
        if reminderSwitch.isOn {
            TaskService.shared.setHideReminder(bool: false)
            TaskService.shared.askToSendNotifications()
            UIView.animate(withDuration: 0.3, animations: {
                self.hideReminderView.frame.origin.y = self.hideReminderView.frame.origin.y+55
            })
        } else {
            TaskService.shared.setHideReminder(bool: true)
            UIView.animate(withDuration: 0.3, animations: {
                self.hideReminderView.frame.origin.y = self.reminderSwitch.frame.maxY
            })
        }
    }
}

//MARK: - TextField Delegate
extension AddAssignmentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
