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
    let dateHeading = makeHeading(withText: "Start Date/End Date:")
    let repeatsHeading = makeHeading(withText: "Repeats Every:")
    let locationHeading = makeHeading(withText: "Location:")
        
    //Stack View
    let classDayStackView = makeStackView(withOrientation: .horizontal, spacing: 5)
    let mainStackView = makeStackView(withOrientation: .vertical, spacing: 3)
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
    let classTimeButton = setValueButton(withPlaceholder: "Set...")
    let dateButton = setValueButton(withPlaceholder: "Set...")
    let spacerView1 = makeSpacerView()
    let spacerView2 = makeSpacerView()
    let spacerView3 = makeSpacerView()
    let spacerView4 = makeSpacerView()
    let spacerView5 = makeSpacerView()

    
    //MARK: - setup UI
    func setupViews() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(classDayStackView)
        view.addSubview(mainStackView)
        view.addSubview(saveButton)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.addSubview(deleteButton)
        
        mainStackView.addArrangedSubview(classTypeHeading)
        mainStackView.addArrangedSubview(classTypeButton)
        mainStackView.addArrangedSubview(spacerView1)
        mainStackView.addArrangedSubview(classDaysHeading)
        mainStackView.addArrangedSubview(classDayStackView)
        mainStackView.addArrangedSubview(spacerView2)
        mainStackView.addArrangedSubview(classTimeHeading)
        mainStackView.addArrangedSubview(classTimeButton)
        mainStackView.addArrangedSubview(spacerView3)
        mainStackView.addArrangedSubview(repeatsHeading)
        mainStackView.addArrangedSubview(repeatsStackView)
        mainStackView.addArrangedSubview(spacerView4)
        mainStackView.addArrangedSubview(dateHeading)
        mainStackView.addArrangedSubview(dateButton)
        mainStackView.addArrangedSubview(spacerView5)
        mainStackView.addArrangedSubview(locationHeading)
        mainStackView.addArrangedSubview(locationTextField)

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
        // backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        deleteButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        deleteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        //deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        
        //Not topView
        mainStackView.anchor(top: topView.bottomAnchor, paddingTop: UIScreen.main.bounds.height/55)
        mainStackView.centerX(in: view)
        
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: 40)
        //saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        sunday.addTarget(self, action: #selector(classDayButtonTapped), for: .touchUpInside)
        
        classTypeButton.addTarget(self, action: #selector(classTypeButtonTapped), for: .touchUpInside)
    }
    
    @objc func classDayButtonTapped(button: UIButton) {
        
        button.setTitleColor(.mainBlue, for: .normal)
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.layer.borderWidth = 4
    }
    
    @objc func classTypeButtonTapped() {
        let vc = ClassTypeViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
