//
//  AddQuizViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-16.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

/*
 * This VC allows the user to add, edit, or delete a Quiz or Exam
 */
class AddQuizAndExamViewController: UIViewController {
    
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
        if SingleClassService.shared.getReminder(){
            reminderSwitch.isOn = true
            reminderSwitchToggled()
        }
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/9)
    let titleLabel = makeTitleLabel(withText: "Add Quiz")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Not topView
    let locationTextField = makeTextField(withPlaceholder: "Location", height: 45)
    let locationView = makeAnimatedView()
    
    let dateButton = makeButtonWithImage(withPlaceholder: "Today", imageName: "calendar")
    
    let startTimeView = PentagonView()
    let endTimeView = UIView()
    
    let timePickerView = makeTimePicker(withHeight: UIScreen.main.bounds.height/4.5)
    let datePickerView = makeDatePicker(withHeight: UIScreen.main.bounds.height/4.5)
    
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
    
    //Top Anchors for locationView
    var locationTopAnchorConstaint = NSLayoutConstraint()
    var locationOtherAnchorConstaint = NSLayoutConstraint()
    
    //Top Anchors for reminderView
    var reminderTopAnchorConstaint = NSLayoutConstraint()
    var reminderOtherAnchorConstaint = NSLayoutConstraint()
    
    //MARK: - setup UI
    func setupViews() {
        clockImage = UIImageView(image: clockIcon!)
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(endTimeView)
        view.addSubview(startTimeView)
        view.addSubview(timePickerView)
        view.addSubview(locationView)
        view.addSubview(hideReminderView)
        view.addSubview(saveButton)
        
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
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
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
        
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        dateButton.anchor(top: locationView.topAnchor,
                          left: startTimeView.leftAnchor,
                          paddingTop: UIScreen.main.bounds.height/50)
        
        datePickerView.anchor(top: dateButton.bottomAnchor)
        datePickerView.centerX(in: view)
        datePickerView.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePickerView.minimumDate = Date()
        
        reminderTopAnchorConstaint = reminderView.topAnchor.constraint(equalTo: dateButton.bottomAnchor)
        reminderOtherAnchorConstaint = reminderView.topAnchor.constraint(equalTo: datePickerView.bottomAnchor)
        reminderTopAnchorConstaint.isActive = true
        
        reminderView.anchor(left: view.leftAnchor, paddingLeft: 20)
        reminderView.setDimensions(height: 275)
        reminderHeading.anchor(top: locationTextField.bottomAnchor,
                               left: view.leftAnchor,
                               paddingTop: UIScreen.main.bounds.height/50,
                               paddingLeft: 20)
        
        reminderSwitch.centerYAnchor.constraint(equalTo: reminderHeading.centerYAnchor).isActive = true
        reminderSwitch.anchor(left: reminderHeading.rightAnchor, paddingLeft: 10)
        reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .touchUpInside)
        reminderSwitch.isOn = false
        
        reminderButton.centerX(in: view)
        reminderButton.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        reminderButton.setTitle(TaskService.shared.setupReminderString(), for: .normal)
        
        hideReminderView.anchor(top: reminderHeading.bottomAnchor, paddingTop: UIScreen.main.bounds.height/80)
        hideReminderView.centerX(in: view)
        hideReminderView.setDimensions(height: 55)
        
        locationView.anchor(left: reminderButton.leftAnchor,
                            bottom: saveButton.topAnchor)
        
        locationTopAnchorConstaint = locationView.topAnchor.constraint(equalTo: startTimeView.bottomAnchor)
        locationOtherAnchorConstaint = locationView.topAnchor.constraint(equalTo: timePickerView.bottomAnchor)
        locationTopAnchorConstaint.isActive = true
        
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
        
        TaskService.shared.setStartTime(time: Date())
        TaskService.shared.setEndTime(time: Date().addingTimeInterval(3600))
        
        if CourseService.shared.getQuizOrExam() != 0 {
            titleLabel.text = "Add Exam"
        }
        
        //If a quiz was selected
        if let quiz = CourseService.shared.getSelectedQuiz(){
            startTime.text = formatTime(from: quiz.startDate)
            endTime.text = formatTime(from: quiz.endDate)
            TaskService.shared.setStartTime(time: quiz.startDate)
            TaskService.shared.setEndTime(time: quiz.endDate)
            datePickerView.date = quiz.startDate
            
            locationTextField.text = quiz.location
            if quiz.reminder {
                reminderButton.setTitle(TaskService.shared.setupReminderString(dateOrTime: quiz.dateOrTime, reminderTime: [quiz.reminderTime[0],quiz.reminderTime[1]],reminderDate: quiz.reminderDate), for: .normal)
                SingleClassService.shared.setReminder(true)
            }
            titleLabel.text = "Edit Quiz"
        }
        
        //If an exam was selected
        if let exam = CourseService.shared.getSelectedExam() {
            startTime.text = formatTime(from: exam.startDate)
            endTime.text = formatTime(from: exam.endDate)
            TaskService.shared.setStartTime(time: exam.startDate)
            TaskService.shared.setEndTime(time: exam.endDate)
            datePickerView.date = exam.startDate
            
            locationTextField.text = exam.location
            
            if exam.reminder {
                reminderButton.setTitle(TaskService.shared.setupReminderString(dateOrTime: exam.dateOrTime, reminderTime: [exam.reminderTime[0], exam.reminderTime[1]], reminderDate: exam.reminderDate), for: .normal)
                SingleClassService.shared.setReminder(true)
            }
            titleLabel.text = "Edit Exam"
        }
        
        if Calendar.current.startOfDay(for: datePickerView.date) == Calendar.current.startOfDay(for: Date()) {
            dateButton.setTitle("Today", for: .normal)
        } else {
            dateButton.setTitle("\(formatDate(from: datePickerView.date))", for: .normal)
        }
    }
    
    func setupTimePickerView() {
        timePickerView.anchor(top: startTimeView.bottomAnchor)
        timePickerView.centerX(in: view)
        timePickerView.setDimensions(width: UIScreen.main.bounds.width - 100)
        timePickerView.backgroundColor = .backgroundColor
        timePickerView.addTarget(self, action: #selector(timePickerDateChanged), for: .valueChanged)
        if Calendar.current.startOfDay(for: datePickerView.date) == Calendar.current.startOfDay(for: Date()) {
            timePickerView.minimumDate = Date()
        } else {
            timePickerView.minimumDate = nil
        }
    }
    
    //MARK: - Actions
    @objc func timePickerDateChanged() {
        locationTopAnchorConstaint.isActive = false
        locationOtherAnchorConstaint.isActive = true
        
        if startTimeView.color == UIColor.mainBlue {
            
            let initialTime = TaskService.shared.getStartTime()
            TaskService.shared.setStartTime(time: timePickerView.date)
            startTime.text = "\(formatTime(from: timePickerView.date))"
            
            let dif = initialTime.distance(to: TaskService.shared.getStartTime())
            TaskService.shared.setEndTime(time: TaskService.shared.getEndTime().addingTimeInterval(dif))
            endTime.text = "\(formatTime(from: TaskService.shared.getEndTime()))"
        } else {
            TaskService.shared.setEndTime(time: timePickerView.date)
            endTime.text  = "\(formatTime(from: timePickerView.date))"
        }
    }
    
    @objc func datePickerChanged() {
        if Calendar.current.startOfDay(for: datePickerView.date) == Calendar.current.startOfDay(for: Date()) {
            timePickerView.minimumDate = Date()
            if TaskService.shared.getStartTime() < Date() {
                TaskService.shared.setStartTime(time: Date())
                startTime.text = "\(formatTime(from: TaskService.shared.getStartTime()))"
            }
            
            if TaskService.shared.getEndTime() < Date() {
                TaskService.shared.setEndTime(time: Date())
                endTime.text = "\(formatTime(from: TaskService.shared.getEndTime()))"
            }
            
        } else {
            timePickerView.minimumDate = nil
        }
        if Calendar.current.startOfDay(for: datePickerView.date) == Calendar.current.startOfDay(for: Date()) {
            dateButton.setTitle("Today", for: .normal)
        } else {
            dateButton.setTitle("\(formatDate(from: datePickerView.date))", for: .normal)
        }
    }
    
    @objc func dateButtonTapped() {
        if self.startTimeView.color == UIColor.mainBlue {
            self.startDateViewTapped()
        } else if self.endTimeView.backgroundColor == UIColor.mainBlue {
            self.endDateViewTapped()
        }
        locationOtherAnchorConstaint.isActive = false
        locationTopAnchorConstaint.isActive = true
        
        if reminderView.frame.origin.y == dateButton.frame.maxY {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.reminderView.frame.origin.y = self.datePickerView.frame.maxY
                })
                self.reminderTopAnchorConstaint.isActive = false
                self.reminderOtherAnchorConstaint.isActive = true
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.reminderView.frame.origin.y = self.dateButton.frame.maxY
                })
                self.reminderTopAnchorConstaint.isActive = true
                self.reminderOtherAnchorConstaint.isActive = false
            }
        }
    }
    
    @objc func startDateViewTapped() {
        if reminderView.frame.origin.y == datePickerView.frame.maxY {
            UIView.animate(withDuration: 0.3, animations: {
                self.reminderView.frame.origin.y = self.dateButton.frame.maxY
            })
        }
        
        reminderTopAnchorConstaint.isActive = true
        reminderOtherAnchorConstaint.isActive = false
        
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
            if Calendar.current.startOfDay(for: datePickerView.date) == Calendar.current.startOfDay(for: Date()) {
                timePickerView.minimumDate = Date()
            } else {
                timePickerView.minimumDate = nil
            }
            
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
        
        reminderTopAnchorConstaint.isActive = true
        reminderOtherAnchorConstaint.isActive = false
        
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
            timePickerView.minimumDate = TaskService.shared.getStartTime()
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
    
    @objc func deleteButtonPressed() {
        
        do {
            try realm.write {
                if CourseService.shared.getQuizOrExam() == 0 {
                    if let quiz = CourseService.shared.getSelectedQuiz() {
                        TaskService.shared.deleteTasks(forQuiz: quiz)
                        realm.delete(quiz)
                    }
                } else {
                    if let exam = CourseService.shared.getSelectedExam() {
                        TaskService.shared.deleteTasks(forExam: exam)
                        realm.delete(exam)
                    }
                }
            }
        } catch {
            print("Error deleting quiz or exam from realm \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: TaskService.shared.getStartTime())
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: TaskService.shared.getEndTime())
        let date = Calendar.current.startOfDay(for: datePickerView.date)
        let course = AllCoursesService.shared.getSelectedCourse()
        do {
            try realm.write {
                if CourseService.shared.getQuizOrExam() == 0 {
                    let quiz = Quiz()
                    quiz.dateOrTime = TaskService.shared.getDateOrTime()
                    quiz.reminder = reminderSwitch.isOn
                    quiz.location = locationTextField.text ?? ""
                    quiz.startDate = date.addingTimeInterval(TimeInterval(startComponents.hour! * 3600 + startComponents.minute! * 60))
                    quiz.endDate = date.addingTimeInterval(TimeInterval(endComponents.hour! * 3600 + endComponents.minute! * 60))
                    quiz.dateOrTime = TaskService.shared.getDateOrTime()
                    quiz.courseId = course?.id ?? ""
                    if quiz.dateOrTime == 0 {
                        let reminderTime = TaskService.shared.getReminderTime()
                        quiz.reminderTime[0] = reminderTime[0]
                        quiz.reminderTime[1] = reminderTime[1]
                    } else {
                        quiz.reminderDate = TaskService.shared.getReminderDate()
                    }
                    //If a previous quiz was selected
                    if let quizToUpdate = CourseService.shared.getSelectedQuiz() {
                        quizToUpdate.startDate = quiz.startDate
                        quizToUpdate.endDate = quiz.endDate
                        quizToUpdate.location = quiz.location
                        quizToUpdate.reminderDate = quiz.reminderDate
                        quizToUpdate.reminderTime[0] = quiz.reminderTime[0]
                        quizToUpdate.reminderTime[1] = quiz.reminderTime[1]
                        quizToUpdate.reminder = quiz.reminder
                        quizToUpdate.dateOrTime = quiz.dateOrTime
                        presentNextVC()
                        TaskService.shared.updateTasks(forQuiz: quizToUpdate)
                        
                    } else {
                        realm.add(quiz, update: .modified)
                        presentNextVC()
                        TaskService.shared.makeTask(forQuiz: quiz)
                        if let course = AllCoursesService.shared.getSelectedCourse() {
                            course.quizzes.append(quiz)
                        }
                    }
                } else {
                    let exam = Exam()
                    exam.dateOrTime = TaskService.shared.getDateOrTime()
                    exam.reminder = reminderSwitch.isOn
                    exam.location = locationTextField.text ?? ""
                    exam.startDate = date.addingTimeInterval(TimeInterval(startComponents.hour! * 3600 + startComponents.minute! * 60))
                    exam.endDate = date.addingTimeInterval(TimeInterval(endComponents.hour! * 3600 + endComponents.minute! * 60))
                    exam.courseId = course?.id ?? ""
                    
                    if exam.dateOrTime == 0 {
                        let reminderTime = TaskService.shared.getReminderTime()
                        exam.reminderTime[0] = reminderTime[0]
                        exam.reminderTime[1] = reminderTime[1]
                    } else {
                        exam.reminderDate = TaskService.shared.getReminderDate()
                    }
                    
                    //If a previous exam was selected
                    if let examToUpdate = CourseService.shared.getSelectedExam() {
                        examToUpdate.startDate = exam.startDate
                        examToUpdate.endDate = exam.endDate
                        examToUpdate.dateOrTime = exam.dateOrTime
                        examToUpdate.location = exam.location
                        examToUpdate.dateOrTime = exam.dateOrTime
                        examToUpdate.reminderDate = exam.reminderDate
                        examToUpdate.reminderTime[0] = exam.reminderTime[0]
                        examToUpdate.reminderTime[1] = exam.reminderTime[1]
                        examToUpdate.reminder = exam.reminder
                        presentNextVC()
                        TaskService.shared.updateTasks(forExam: examToUpdate)
                        
                    } else {
                        realm.add(exam, update: .modified)
                        presentNextVC()
                        TaskService.shared.makeTask(forExam: exam)
                        if let course = AllCoursesService.shared.getSelectedCourse() {
                            course.exams.append(exam)
                        }
                    }
                }
            }
        } catch {
            print("Error writing Class to realm \(error.localizedDescription)")
        }
        
  presentNextVC()
    }
    
    func presentNextVC() {
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
        if CourseService.shared.getQuizOrExam() == 0 {
            TaskService.shared.setReminderDate(date: CourseService.shared.getSelectedQuiz()?.reminderDate ?? Date())
        } else {
            TaskService.shared.setReminderDate(date: CourseService.shared.getSelectedExam()?.reminderDate ?? Date())
        }
        let vc = SetReminderViewController()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if startTimeView.color == UIColor.mainBlue || endTimeView.backgroundColor == UIColor.mainBlue{
            locationOtherAnchorConstaint.isActive = true
            locationTopAnchorConstaint.isActive = false
        }
    }
}
