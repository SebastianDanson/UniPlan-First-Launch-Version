//
//  AddClassViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class AddClassViewController: UIViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        classTypeButton.setTitle(SingleClassService.shared.getType().description, for: .normal)
        setInitialClassTime()
        setInitialClassDates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sunday.layer.cornerRadius = sunday.frame.width/2
        monday.layer.cornerRadius = sunday.frame.width/2
        tuesday.layer.cornerRadius = sunday.frame.width/2
        wednesday.layer.cornerRadius = sunday.frame.width/2
        thursday.layer.cornerRadius = sunday.frame.width/2
        friday.layer.cornerRadius = sunday.frame.width/2
        saturday.layer.cornerRadius = sunday.frame.width/2
        
        reminderButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: reminderButton.frame.width-20, bottom: 0, right: 0)
        classTimeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: classTimeButton.frame.width-20, bottom: 0, right: 0)
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Add Class")
    let backButton = makeBackButton()
    let deleteButton = makeDeleteButton()
    
    //Headings
    let classTypeHeading = makeHeading(withText: "Type:")
    let classDaysHeading = makeHeading(withText: "Days:")
    let classTimeHeading = makeHeading(withText: "Time:")
    let reminderHeading = makeHeading(withText: "Reminder:")
    let dateHeading = makeHeading(withText: "Start Date/End Date:")
    let repeatsHeading = makeHeading(withText: "Repeats Every:")
    let locationHeading = makeHeading(withText: "Location:")
    
    //Stack View
    let classDayStackView = makeStackView(withOrientation: .horizontal, spacing: 5)
    let topStackView = makeStackView(withOrientation: .vertical, spacing: 3)
    let timeAndReminderButtonsStackView = makeStackView(withOrientation: .horizontal, spacing: 10)
    let bottomStackView = makeStackView(withOrientation: .vertical, spacing: 3)
    let repeatsStackView = makeStackView(withOrientation: .horizontal, spacing: 16)
    
    //Class Day Circles
    let sunday = makeClassDaysCircleButton(withLetter: "S")
    let monday = makeClassDaysCircleButton(withLetter: "M")
    let tuesday = makeClassDaysCircleButton(withLetter: "T")
    let wednesday = makeClassDaysCircleButton(withLetter: "W")
    let thursday = makeClassDaysCircleButton(withLetter: "T")
    let friday = makeClassDaysCircleButton(withLetter: "F")
    let saturday = makeClassDaysCircleButton(withLetter: "S")
    
    //Repeat Buttons
    let everyWeekButton = makeRepeatsButton(withText: "Week")
    let everyTwoWeeksButton = makeRepeatsButton(withText: "2 Weeks")
    let everyMonthButton = makeRepeatsButton(withText: "Month")
    
    //Others
    let locationTextField = makeTextField(withPlaceholder: "Location")
    let saveButton = makeSaveButton()
    let classTypeButton = setValueButton(withPlaceholder: "Class")
    let classTimeButton = setValueButtonNoWidth(withPlaceholder: "Set...")
    let reminderButton = setValueButtonNoWidth(withPlaceholder: "None")
    let dateButton = setValueButton(withPlaceholder: "Set...")
    let spacerView1 = makeSpacerView()
    let spacerView2 = makeSpacerView()
    let spacerView3 = makeSpacerView()

    
    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(classDayStackView)
        view.addSubview(topStackView)
        view.addSubview(saveButton)
        view.addSubview(reminderHeading)
        view.addSubview(classTimeHeading)
        view.addSubview(timeAndReminderButtonsStackView)
        view.addSubview(bottomStackView)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.addSubview(deleteButton)
        
        topStackView.addArrangedSubview(classTypeHeading)
        topStackView.addArrangedSubview(classTypeButton)
        topStackView.addArrangedSubview(spacerView1)
        topStackView.addArrangedSubview(classDaysHeading)
        topStackView.addArrangedSubview(classDayStackView)
        
        timeAndReminderButtonsStackView.addArrangedSubview(classTimeButton)
        timeAndReminderButtonsStackView.addArrangedSubview(reminderButton)
        timeAndReminderButtonsStackView.distribution = .fillEqually


        bottomStackView.addArrangedSubview(timeAndReminderButtonsStackView)
        bottomStackView.addArrangedSubview(repeatsHeading)
        bottomStackView.addArrangedSubview(repeatsStackView)
        bottomStackView.addArrangedSubview(spacerView2)
        bottomStackView.addArrangedSubview(dateHeading)
        bottomStackView.addArrangedSubview(dateButton)
        bottomStackView.addArrangedSubview(spacerView3)
        bottomStackView.addArrangedSubview(locationHeading)
        bottomStackView.addArrangedSubview(locationTextField)
        
        classDayStackView.addArrangedSubview(sunday)
        classDayStackView.addArrangedSubview(monday)
        classDayStackView.addArrangedSubview(tuesday)
        classDayStackView.addArrangedSubview(wednesday)
        classDayStackView.addArrangedSubview(thursday)
        classDayStackView.addArrangedSubview(friday)
        classDayStackView.addArrangedSubview(saturday)
        classDayStackView.distribution = .fillEqually
        
        repeatsStackView.addArrangedSubview(everyWeekButton)
        repeatsStackView.addArrangedSubview(everyTwoWeeksButton)
        repeatsStackView.addArrangedSubview(everyMonthButton)
        repeatsStackView.distribution = .fillEqually
        
        //topView
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        deleteButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        deleteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        //deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        
        //Not topView
        topStackView.anchor(top: topView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/55)
        topStackView.centerX(in: view)
        topStackView.setDimensions(width: UIScreen.main.bounds.width - 40)
        
        classTimeHeading.anchor(top: topStackView.bottomAnchor, left: topStackView.leftAnchor, paddingTop: 5)
        reminderHeading.anchor(top: topStackView.bottomAnchor, left: reminderButton.leftAnchor, paddingTop: 5)

        bottomStackView.anchor(top: reminderHeading.bottomAnchor)
        bottomStackView.centerX(in: view)
        
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: 40)
        saveButton.addTarget(self, action: #selector(saveClass), for: .touchUpInside)
        
        //Setting button tags
        sunday.tag = 0
        monday.tag = 1
        tuesday.tag = 2
        wednesday.tag = 3
        thursday.tag = 4
        friday.tag = 5
        saturday.tag = 6
        
        //Adding targets to day buttons
        sunday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        monday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        tuesday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        wednesday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        thursday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        friday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        saturday.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        
        classTypeButton.addTarget(self, action: #selector(typeButtonTapped), for: .touchUpInside)
        classTimeButton.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
        
        everyWeekButton.addTarget(self, action: #selector(repeatsButtonTapped), for: .touchUpInside)
        everyTwoWeeksButton.addTarget(self, action: #selector(repeatsButtonTapped), for: .touchUpInside)
        everyMonthButton.addTarget(self, action: #selector(repeatsButtonTapped), for: .touchUpInside)
        
        reminderButton.addTarget(self, action: #selector(reminderButtonPressed), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc func dayButtonTapped(button: UIButton) {
        if SingleClassService.shared.getClassDays()[button.tag] == 0 {
            button.highlight()
        } else {
            button.unhighlight()
        }
        SingleClassService.shared.setClassDay(day: button.tag)
    }
    
    @objc func typeButtonTapped() {
        let vc = ClassTypeViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func timeButtonTapped() {
        let vc = SetClassTimeViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func dateButtonTapped() {
        let vc = SetClassDatesViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func repeatsButtonTapped(button: UIButton) {
        everyWeekButton.unhighlight()
        everyTwoWeeksButton.unhighlight()
        everyMonthButton.unhighlight()
        
        if SingleClassService.shared.getRepeats() != button.titleLabel?.text {
            button.highlight()
            SingleClassService.shared.setRepeats(every: button.titleLabel?.text ?? "Never")
            return
        }
        SingleClassService.shared.setRepeats(every: "Never")
    }
    
    @objc func reminderButtonPressed() {
        let vc = SetTaskReminderViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func saveClass() {
        let theClass = SingleClass()
        theClass.classDays = configureClassDays()
        theClass.classStartDate = SingleClassService.shared.getStartDate()
        theClass.classEndDate = SingleClassService.shared.getEndDate()
        theClass.startTime = SingleClassService.shared.getStartTime()
        theClass.endTime = SingleClassService.shared.getEndTime()
        theClass.repeats = SingleClassService.shared.getRepeats()
        theClass.location = locationTextField.text ?? ""
        theClass.type = SingleClassService.shared.getType().description
        //theClass.reminderTime = SingleClassService.shared.get
        
        do {
            try realm.write {
                realm.add(theClass)
            }
        }catch {
            print("Error writing Class to realm \(error.localizedDescription)")
        }
        dismiss(animated: true)
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true)
    }
    //MARK: - Helper methods
    func setInitialClassTime() {
        //        if SingleClassService.shared.getStartDate == SingleClassService.shared.getEndDate {
        //            classTimeButton.setTitle("Set...", for: .normal)
        //        } else {
        classTimeButton.setTitle("\(SingleClassService.shared.getStartTimeAsString())-\(SingleClassService.shared.getEndTimeAsString())", for: .normal)
        //}
    }
    
    func setInitialClassDates() {
        //        if SingleClassService.shared.getStartDate == SingleClassService.shared.getEndDate {
        //            classTimeButton.setTitle("Set...", for: .normal)
        //        } else {
        dateButton.setTitle("\(SingleClassService.shared.getStartDateAsString()) - \(SingleClassService.shared.getEndDateAsString())",
            for: .normal)
        //}
    }
    
    func configureClassDays() -> List<Int> {
        let days = List<Int>()
        days.append(objectsIn: SingleClassService.shared.getClassDays())
        return days
    }
}
