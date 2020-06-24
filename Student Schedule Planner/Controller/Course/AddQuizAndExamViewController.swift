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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupReminderTime()
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
    let reminderHeading = makeHeading(withText: "Reminder")
    let reminderSwitch = UISwitch()
    let reminderButton = setValueButton(withPlaceholder: "When Task Starts")
    let locationHeading = makeHeading(withText: "Location")
    let locationTextField = makeTextField(withPlaceholder: "Location")

    
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
        view.addSubview(reminderButton)
        view.addSubview(reminderSwitch)
        view.addSubview(reminderHeading)
        view.addSubview(locationHeading)
        view.addSubview(locationTextField)
        
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
        
        reminderHeading.anchor(top: endTimePicker.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/25, paddingLeft: 20)
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        reminderButton.isHidden = true
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        
        locationHeading.anchor(top: reminderButton.bottomAnchor, left: reminderButton.leftAnchor, paddingTop: UIScreen.main.bounds.height/25)
        locationTextField.anchor(top: locationHeading.bottomAnchor, left: locationHeading.leftAnchor, paddingTop: 15)
        
        saveButton.anchor(top: locationTextField.bottomAnchor, paddingTop: UIScreen.main.bounds.height/10)
        saveButton.centerX(in: view)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        if let quizIndex = QuizService.shared.getQuizIndex(){
            if let quiz = CourseService.shared.getQuiz(atIndex: quizIndex) {
                datePicker.date = quiz.startDate
                endTimePicker.date = quiz.endDate
            }
        }
        
        if let examIndex = ExamService.shared.getExamIndex(){
            if let exam = CourseService.shared.getExam(atIndex: examIndex) {
                datePicker.date = exam.startDate
                endTimePicker.date = exam.endDate
            }
        }
    }
    
    func setupReminderTime() {
        reminderButton.isHidden = TaskService.shared.getHideReminder()
        reminderSwitch.isOn = !reminderButton.isHidden
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        do {
            try realm.write {
                if CourseService.shared.getQuizOrExam() == 0 {
                    var quiz = Quiz()
                    quiz.startDate = datePicker.date
                    quiz.endDate = endTimePicker.date
                    
                    if let quizIndex = QuizService.shared.getQuizIndex() {
                        var quizToUpdate = CourseService.shared.getQuiz(atIndex: quizIndex)
                        quizToUpdate?.startDate = quiz.startDate
                        quizToUpdate?.endDate = quiz.endDate
                    } else {
                        realm.add(quiz, update: .modified)
                        if let course = AllCoursesService.shared.getSelectedCourse() {
                            course.quizzes.append(quiz)
                        }
                    }
                } else {
                    var exam = Exam()
                    exam.startDate = datePicker.date
                    exam.endDate = endTimePicker.date
                    
                    if let examIndex = ExamService.shared.getExamIndex(){
                        var examToUpdate = CourseService.shared.getExam(atIndex: examIndex)
                        examToUpdate?.startDate = exam.startDate
                        examToUpdate?.endDate = exam.endDate
                    } else {
                        realm.add(exam, update: .modified)
                        if let course = AllCoursesService.shared.getSelectedCourse() {
                            course.exams.append(exam)
                        }
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
