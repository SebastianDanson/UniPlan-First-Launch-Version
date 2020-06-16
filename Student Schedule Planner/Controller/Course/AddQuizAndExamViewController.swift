//
//  AddQuizViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-16.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class AddQuizAndExamViewController: UIViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        setupViews()
    }
    
    //MARK: - Properties
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Add Quiz")
    let backButton = makeBackButton()
    let saveButton = makeSaveButton()
    let dateHeading = makeHeading(withText: "Start Date:")
    let endTimeHeading = makeHeading(withText: "End Time")
    let endTimePicker = makeTimePicker()
    let datePicker = makeDateAndTimePicker(height: UIScreen.main.bounds.height/6)
    
    //MARK: - UI Setup
    func setupViews() {
        if CourseService.shared.getQuizOrExam() != 0 {
            titleLabel.text = "Add Exam"
        }
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(saveButton)
        view.addSubview(dateHeading)
        view.addSubview(datePicker)
        view.addSubview(endTimeHeading)
        view.addSubview(endTimePicker)
        
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
        dateHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        datePicker.anchor(top: dateHeading.bottomAnchor)
        datePicker.centerX(in: view)
        
        endTimeHeading.anchor(top: datePicker.bottomAnchor, left: dateHeading.leftAnchor, paddingTop: 15)
        endTimePicker.anchor(top: endTimeHeading.bottomAnchor, left: endTimeHeading.leftAnchor)
        
        saveButton.anchor(top: endTimePicker.bottomAnchor, paddingTop: UIScreen.main.bounds.height/10)
        saveButton.centerX(in: view)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        //        AssignmentService.shared.setTitle(title: titleTextField.text ?? "Untitled")
        //        AssignmentService.shared.setDueDate(date: datePicker.date)
        
        
        do {
            try realm.write {
                if CourseService.shared.getQuizOrExam() == 0 {
                    var quiz = Quiz()
                    quiz.startDate = datePicker.date
                    quiz.endTime = endTimePicker.date
                    realm.add(quiz)
                } else {
                    var exam = Exam()
                    exam.startDate = datePicker.date
                    exam.endTime = endTimePicker.date
                    realm.add(exam)
                }
            }
        } catch {
            print("Error writing Class to realm \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
    }
}
