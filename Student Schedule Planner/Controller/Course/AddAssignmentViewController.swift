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
    
    //MARK: - Properties
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Add Assignment")
    let backButton = makeBackButton()
    let saveButton = makeSaveButton()
    let titleHeading = makeHeading(withText: "Title:")
    let titleTextField = makeTextField(withPlaceholder: "Assignment Title")
    let dateHeading = makeHeading(withText: "Date:")
    let datePicker = makeDateAndTimePicker(height: UIScreen.main.bounds.height/6)
    
    //MARK: - UI Setup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(saveButton)
        view.addSubview(titleHeading)
        view.addSubview(titleTextField)
        view.addSubview(dateHeading)
        view.addSubview(datePicker)
        
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
        
        saveButton.anchor(top: datePicker.bottomAnchor, paddingTop: UIScreen.main.bounds.height/10)
        saveButton.centerX(in: view)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        if let assignmentIndex = AssignmentService.shared.getAssignmentIndex(){
            if let assignment = CourseService.shared.getAssignment(atIndex: assignmentIndex) {
                titleTextField.text = assignment.title
                datePicker.date = assignment.dueDate
            }
        }
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        //        AssignmentService.shared.setTitle(title: titleTextField.text ?? "Untitled")
        //        AssignmentService.shared.setDueDate(date: datePicker.date)
        
        var assignment = Assignment()
        assignment.title = titleTextField.text ?? "Untitled"
        assignment.dueDate = datePicker.date
        do {
            try realm.write {
                if let assignmentIndex = AssignmentService.shared.getAssignmentIndex() {
                    var assignmentToUpdate = CourseService.shared.getAssignment(atIndex: assignmentIndex)
                    assignmentToUpdate?.title = assignment.title
                    assignmentToUpdate?.dueDate = assignment.dueDate
                } else {
                    realm.add(assignment, update: .modified)
                }
            }
        } catch {
            print("Error writing Class to realm \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
    }
}
