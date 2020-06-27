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
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
    let titleLabel = makeTitleLabel(withText: "Add Class")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Not topView
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
    let hideReminderView = makeAnimatedView()
    
    let saveButton = makeSaveButton()
    
    let clockIcon = UIImage(systemName: "clock.fill")
    var clockImage = UIImageView(image: nil)
    
    var reminderTopAnchorConstaint = NSLayoutConstraint()
    var reminderOtherAnchorConstaint = NSLayoutConstraint()
    
    var locationTopAnchorConstaint = NSLayoutConstraint()
    var locationOtherAnchorConstaint = NSLayoutConstraint()
    
    
    //MARK: - setup UI
    func setupViews() {
        clockImage = UIImageView(image: clockIcon!)
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(endTimeView)
        view.addSubview(startTimeView)
        view.addSubview(timePickerView)
        view.addSubview(locationView)
        view.addSubview(saveButton)
        view.addSubview(hideReminderView)
        
        locationView.addSubview(dateButton)
        locationView.addSubview(datePickerView)
        locationView.addSubview(reminderView)
        
        reminderView.addSubview(locationTextField)
        reminderView.addSubview(reminderHeading)
        reminderView.addSubview(reminderButton)
        reminderView.addSubview(reminderSwitch)
        reminderView.addSubview(hideReminderView)
        
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
        //deleteButton.addTarget(self, action: #selector(deletebutt), for: .touchUpInside)
        
        //Not topView
        let startTap = UITapGestureRecognizer(target: self, action: #selector(startDateViewTapped))
        startTimeView.setDimensions(width: UIScreen.main.bounds.width/2,
                                    height: UIScreen.main.bounds.height/15)
        startTimeView.addGestureRecognizer(startTap)
        startTimeView.anchor(top: topView.bottomAnchor,
                             left: view.leftAnchor,
                             paddingTop: UIScreen.main.bounds.height/50,
                             paddingLeft: 20)
        
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
        
        endTimeView.anchor(top: topView.bottomAnchor,
                           right: view.rightAnchor,
                           paddingTop: UIScreen.main.bounds.height/50,
                           paddingRight: 20)
        
        startTime.centerX(in: startTimeView)
        startTime.centerY(in: startTimeView)
        
        endTime.centerX(in: endTimeView)
        endTime.centerY(in: endTimeView)
        
        dateButton.anchor(top: locationView.topAnchor,
                          left: startTimeView.leftAnchor,
                          paddingTop: UIScreen.main.bounds.height/50)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        
        datePickerView.anchor(top: dateButton.bottomAnchor)
        datePickerView.centerX(in: view)
        datePickerView.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        reminderView.topAnchor.constraint(equalTo: dateButton.bottomAnchor).isActive = true
        reminderView.anchor(left: view.leftAnchor, paddingLeft: 20)
        reminderView.setDimensions(height: 275)
        reminderHeading.anchor(top: locationTextField.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/50, paddingLeft: 20)
        
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
        
        hideReminderView.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        hideReminderView.centerX(in: view)
        hideReminderView.setDimensions(height: 55)
        
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
        
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: UIScreen.main.bounds.height/15)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        setupTimePickerView()
        
        startTime.text = "\(formatTime(from: Date()))"
        endTime.text = "\(formatTime(from: Date().addingTimeInterval(3600)))"
        
        
        if let quizIndex = QuizService.shared.getQuizIndex(){
            if let quiz = CourseService.shared.getQuiz(atIndex: quizIndex) {
                startTime.text = formatTime(from: quiz.startDate)
                endTime.text = formatTime(from: quiz.endDate)
                locationTextField.text = quiz.location
                if quiz.reminder {
                    reminderButton.setTitle(TaskService.shared.setupReminderString(dateOrTime: quiz.dateOrTime, reminderTime: [quiz.reminderTime[0],quiz.reminderTime[1]],reminderDate: quiz.reminderDate), for: .normal)
                    SingleClassService.shared.setReminder(true)
                }
            }
        }
        
        if let examIndex = ExamService.shared.getExamIndex(){
            if let exam = CourseService.shared.getExam(atIndex: examIndex) {
                startTime.text = formatTime(from: exam.startDate)
                endTime.text = formatTime(from: exam.endDate)
                locationTextField.text = exam.location
                if exam.reminder {
                    reminderButton.setTitle(TaskService.shared.setupReminderString(dateOrTime: exam.dateOrTime, reminderTime: [exam.reminderTime[0], exam.reminderTime[1]], reminderDate: exam.reminderDate), for: .normal)
                    reminderSwitch.isOn = true
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
    
    //MARK: - Actions
    @objc func reminderSwitchToggled() {
        if reminderSwitch.isOn {
            TaskService.shared.setHideReminder(bool: false)
            TaskService.shared.askToSendNotifications()
            UIView.animate(withDuration: 0.3, animations: {
                self.hideReminderView.frame.origin.y = self.hideReminderView.frame.origin.y+45
            })
        } else {
            TaskService.shared.setHideReminder(bool: true)
            UIView.animate(withDuration: 0.3, animations: {
                self.hideReminderView.frame.origin.y = self.hideReminderView.frame.origin.y-45
            })
        }
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        do {
            try realm.write {
                if CourseService.shared.getQuizOrExam() == 0 {
                    var quiz = Quiz()
                    quiz.dateOrTime = TaskService.shared.getDateOrTime()
                    quiz.reminder = reminderSwitch.isOn
                    quiz.location = locationTextField.text ?? ""
                    if quiz.dateOrTime == 0 {
                        let reminderTime = TaskService.shared.getReminderTime()
                        quiz.reminderTime[0] = reminderTime[0]
                        quiz.reminderTime[1] = reminderTime[1]
                    } else {
                        quiz.reminderDate = TaskService.shared.getReminderDate()
                    }
                    
                    if let quizIndex = QuizService.shared.getQuizIndex() {
                        var quizToUpdate = CourseService.shared.getQuiz(atIndex: quizIndex)
                        quizToUpdate?.startDate = quiz.startDate
                        quizToUpdate?.endDate = quiz.endDate
                        quizToUpdate?.location = quiz.location
                    } else {
                        realm.add(quiz, update: .modified)
                        if let course = AllCoursesService.shared.getSelectedCourse() {
                            course.quizzes.append(quiz)
                        }
                    }
                } else {
                    let exam = Exam()
                    exam.dateOrTime = TaskService.shared.getDateOrTime()
                    exam.reminder = reminderSwitch.isOn
                    exam.location = locationTextField.text ?? ""
                    if exam.dateOrTime == 0 {
                        let reminderTime = TaskService.shared.getReminderTime()
                        exam.reminderTime[0] = reminderTime[0]
                        exam.reminderTime[1] = reminderTime[1]
                    } else {
                        exam.reminderDate = TaskService.shared.getReminderDate()
                    }
                    
                    if let examIndex = ExamService.shared.getExamIndex(){
                        let examToUpdate = CourseService.shared.getExam(atIndex: examIndex)
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
}

//MARK: - TextField Delegate
extension AddQuizAndExamViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
