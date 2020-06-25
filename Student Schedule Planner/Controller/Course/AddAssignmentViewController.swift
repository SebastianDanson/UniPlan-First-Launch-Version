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
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupReminderTime()
    }
    
    //MARK: - Properties
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "Add Assignment")
    let backButton = makeBackButton()
    let saveButton = makeSaveButton()
    let titleHeading = makeHeading(withText: "Title:")
    let titleTextField = makeTextField(withPlaceholder: "Assignment Title", height: UIScreen.main.bounds.height/20 )
    let dateHeading = makeHeading(withText: "Date:")
    let datePicker = makeDateAndTimePicker(height: UIScreen.main.bounds.height/6)
    let reminderHeading = makeHeading(withText: "Reminder")
    let reminderSwitch = UISwitch()
    let reminderButton = setValueButton(withPlaceholder: "When Task Starts")
    
    //MARK: - UI Setup
    func setupViews() {
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(saveButton)
        view.addSubview(titleHeading)
        view.addSubview(titleTextField)
        view.addSubview(dateHeading)
        view.addSubview(datePicker)
        view.addSubview(reminderButton)
        view.addSubview(reminderSwitch)
        view.addSubview(reminderHeading)
        
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
        titleHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        titleTextField.anchor(top: titleHeading.bottomAnchor, left: titleHeading.leftAnchor, paddingTop: 5)
        dateHeading.anchor(top: titleTextField.bottomAnchor, left: titleTextField.leftAnchor, paddingTop: 25)
        datePicker.anchor(top: dateHeading.bottomAnchor)
        datePicker.centerX(in: view)
        
        reminderHeading.anchor(top: datePicker.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/25, paddingLeft: 20)
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        reminderButton.isHidden = true
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        
        saveButton.anchor(top: reminderButton.bottomAnchor, paddingTop: UIScreen.main.bounds.height/10)
        saveButton.centerX(in: view)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        if let assignmentIndex = AssignmentService.shared.getAssignmentIndex(){
            if let assignment = CourseService.shared.getAssignment(atIndex: assignmentIndex) {
                titleTextField.text = assignment.title
                datePicker.date = assignment.dueDate
            }
        }
    }
    
    func setupReminderTime() {
        reminderButton.isHidden = TaskService.shared.getHideReminder()
        reminderSwitch.isOn = !reminderButton.isHidden
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
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
            reminderButton.isHidden = false
            TaskService.shared.setHideReminder(bool: false)
            TaskService.shared.askToSendNotifications()
        } else {
            reminderButton.isHidden = true
            TaskService.shared.setHideReminder(bool: true)
        }
    }
}
