//
//  AddAssignmentViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-16.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

/*
 * This VC allows the user to add, edit, or delete an Assignment
 */
class AddAssignmentViewController: UIViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        TaskService.shared.setReminderTime([0, 0])
        TaskService.shared.setReminderDate(date: Date())
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
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "Add Assignment")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //not topView
    let saveButton = makeSaveButton()
    let titleTextField = makeTextField(withPlaceholder: "Title", height: 50)
    
    let dateHeading = makeHeading(withText: "Due Date:")
    let datePicker = makeDateAndTimePicker(height: UIScreen.main.bounds.height/4.5)
    
    let reminderHeading = makeHeading(withText: "Reminder")
    let reminderSwitch = UISwitch()
    let reminderButton = setValueButton(withPlaceholder: "When Task Starts", height: 45)
    let hideReminderView = makeAnimatedView()
    
    //Top Anchors for reminderView
    var reminderViewTopAnchorConstaint = NSLayoutConstraint()
    var reminderViewOtherAnchorConstaint = NSLayoutConstraint()
    
    //MARK: - UI Setup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(titleTextField)
        view.addSubview(dateHeading)
        view.addSubview(datePicker)
        view.addSubview(reminderButton)
        view.addSubview(reminderSwitch)
        view.addSubview(reminderHeading)
        view.addSubview(hideReminderView)
        view.addSubview(saveButton)
        
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
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        //Not topView
        titleTextField.layer.borderWidth = 5
        titleTextField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleTextField.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        titleTextField.delegate = self
        dateHeading.anchor(top: titleTextField.bottomAnchor, left: titleTextField.leftAnchor, paddingTop: 25)
        
        datePicker.anchor(top: dateHeading.bottomAnchor)
        datePicker.centerX(in: view)
        datePicker.minimumDate = Date()
        
        reminderHeading.anchor(top: datePicker.bottomAnchor,
                               left: view.leftAnchor,
                               paddingTop: UIScreen.main.bounds.height/25,
                               paddingLeft: 20)
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        reminderSwitch.isOn = false
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        
        
        reminderViewOtherAnchorConstaint = hideReminderView.topAnchor.constraint(equalTo: reminderButton.bottomAnchor)
        reminderViewTopAnchorConstaint = hideReminderView.topAnchor.constraint(equalTo: reminderSwitch.bottomAnchor)
        reminderViewTopAnchorConstaint.isActive = true
        hideReminderView.centerX(in: view)
        hideReminderView.setDimensions(height: 55)
        
        saveButton.anchor(top: reminderButton.bottomAnchor, paddingTop: UIScreen.main.bounds.height/10)
        saveButton.centerX(in: view)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        //If an assignment was selected
        if let assignment = CourseService.shared.getSelectedAssignment() {
            titleTextField.text = assignment.title
            datePicker.date = assignment.dueDate
            reminderSwitch.isOn = assignment.reminder
            titleLabel.text = "Edit Assignment"
            
            if assignment.reminder {
                reminderButton.setTitle(TaskService.shared.setupReminderString(dateOrTime: assignment.dateOrTime, reminderTime: [assignment.reminderTime[0],assignment.reminderTime[1]], reminderDate: assignment.reminderDate), for: .normal)
                SingleClassService.shared.setReminder(true)
            }
        }
    }
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteButtonPressed() {
        //deletes the assignment and the task associated with it
        if let assignment = CourseService.shared.getSelectedAssignment() {
            do {
                try realm.write{
                    TaskService.shared.deleteTasks(forAssigment: assignment)
                    realm.delete(assignment)
                }
            } catch {
                print("Error deleting assignment from realm \(error.localizedDescription)")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        let course = AllCoursesService.shared.getSelectedCourse()
        let assignment = Assignment()
        assignment.title = titleTextField.text ?? "Untitled"
        assignment.dueDate = datePicker.date
        assignment.dateOrTime = TaskService.shared.getDateOrTime()
        assignment.reminder = reminderSwitch.isOn
        assignment.courseId = course?.id ?? ""
        
        if assignment.dateOrTime == 0 {
            let reminderTime = TaskService.shared.getReminderTime()
            assignment.reminderTime[0] = reminderTime[0]
            assignment.reminderTime[1] = reminderTime[1]
        } else {
            assignment.reminderDate = TaskService.shared.getReminderDate()
        }
        
        do {
            try realm.write {
                //If an assignment was selected
                if let assignmentToUpdate = CourseService.shared.getSelectedAssignment() {
                    assignmentToUpdate.title = assignment.title
                    assignmentToUpdate.dueDate = assignment.dueDate
                    assignmentToUpdate.reminderTime[0] = assignment.reminderTime[0]
                    assignmentToUpdate.reminderTime[1] = assignment.reminderTime[1]
                    assignmentToUpdate.reminderDate = assignment.reminderDate
                    assignmentToUpdate.reminder = assignment.reminder
                    assignmentToUpdate.dateOrTime = assignment.dateOrTime
                    TaskService.shared.updateTasks(forAssignment: assignmentToUpdate)
                    
                } else {
                    realm.add(assignment, update: .modified)
                    TaskService.shared.makeTask(forAssignment: assignment)
                    if let course = AllCoursesService.shared.getSelectedCourse() {
                        course.assignments.append(assignment)
                    }
                }
            }
        } catch {
            print("Error writing Class to realm \(error.localizedDescription)")
        }
        if AllCoursesService.shared.getAddSummative() {
            AllCoursesService.shared.setAddSummative(bool: false)
            let vc = TabBarController()
            vc.selectedIndex = 2
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func reminderButtonPressed() {
        let vc = SetReminderViewController()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !reminderSwitch.isOn {
            reminderViewTopAnchorConstaint.isActive = true
            reminderViewOtherAnchorConstaint.isActive = false
        } else {
            reminderViewTopAnchorConstaint.isActive = false
            reminderViewOtherAnchorConstaint.isActive = true
        }
        
    }
}
