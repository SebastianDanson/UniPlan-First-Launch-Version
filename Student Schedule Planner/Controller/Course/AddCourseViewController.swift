//
//  AddCourseViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-18.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class AddCourseViewController: PickerViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setClassDates()
        CourseService.shared.setColor(int: 0)
    }
    
    //MARK: - properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Add Course")
    let backButton = makeBackButton()
    
    //Not topView
    let titleHeading = makeHeading(withText: "Course Name:")
    let titleTextField = makeTextField(withPlaceholder: "Course Name:")
    let dateHeading = makeHeading(withText: "Start Date/End Date")
    let setDateButton = setValueButton(withPlaceholder: "Set...")
    let colorHeading = makeHeading(withText: "Color:")
    let colorStackView = makeStackView(withOrientation: .horizontal, spacing: 3)
    let saveButton = makeSaveButton()
    
    //Color Buttons
    let red = makeColorButton(ofColor: .alizarin)
    let orange = makeColorButton(ofColor: .carrot)
    let yellow = makeColorButton(ofColor: .sunflower)
    let green = makeColorButton(ofColor: .emerald)
    let turquoise = makeColorButton(ofColor: .turquoise)
    let blue = makeColorButton(ofColor: .riverBlue)
    let darkBlue = makeColorButton(ofColor: .midnightBlue)
    let purple = makeColorButton(ofColor: .amethyst)
    
    //MARK: - UISetup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(titleHeading)
        view.addSubview(titleTextField)
        view.addSubview(dateHeading)
        view.addSubview(setDateButton)
        view.addSubview(colorHeading)
        view.addSubview(colorStackView)
        view.addSubview(saveButton)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        
        colorStackView.addArrangedSubview(red)
        colorStackView.addArrangedSubview(orange)
        colorStackView.addArrangedSubview(yellow)
        colorStackView.addArrangedSubview(green)
        colorStackView.addArrangedSubview(turquoise)
        colorStackView.addArrangedSubview(blue)
        colorStackView.addArrangedSubview(darkBlue)
        colorStackView.addArrangedSubview(purple)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        titleHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        titleTextField.anchor(top: titleHeading.bottomAnchor, left: titleHeading.leftAnchor, paddingTop: 5)
        
        dateHeading.anchor(top: titleTextField.bottomAnchor, left: titleTextField.leftAnchor, paddingTop: 20)
        setDateButton.anchor(top: dateHeading.bottomAnchor, left: dateHeading.leftAnchor, paddingTop: 5)
        setDateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        
        colorHeading.anchor(top: setDateButton.bottomAnchor, left: setDateButton.leftAnchor, paddingTop: 20)
        colorStackView.anchor(top: colorHeading.bottomAnchor, left: colorHeading.leftAnchor, paddingTop: 5)
        
        saveButton.centerX(in: view)
        saveButton.anchor(bottom: view.bottomAnchor, paddingBottom: 40)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        red.tag = 0
        orange.tag = 1
        yellow.tag = 2
        green.tag = 3
        turquoise.tag = 4
        blue.tag = 5
        darkBlue.tag = 6
        purple.tag = 7

        red.alpha = 0.3
        red.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        orange.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        yellow.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        green.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        turquoise.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        blue.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        darkBlue.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        purple.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dateButtonTapped() {
        let vc = SetClassDatesViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        do {
            try realm.write {
                let course = Course()
                course.title = titleTextField.text ?? "Unitled"
                course.startDate = CourseService.shared.getStartDate()
                course.endDate = CourseService.shared.getEndDate()
                course.color = CourseService.shared.getColor()
                realm.add(course)
            }
        } catch {
            print("Error saving course to realm \(error.localizedDescription)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func colorButtonPressed(button: UIButton) {
        red.alpha = 1
        orange.alpha = 1
        yellow.alpha = 1
        green.alpha = 1
        turquoise.alpha = 1
        blue.alpha = 1
        darkBlue.alpha = 1
        purple.alpha = 1

        button.alpha = 0.3
        CourseService.shared.setColor(int: button.tag)
    }
    
    //MARK: - Helper functions
    func setClassDates() {
        setDateButton.setTitle("\(CourseService.shared.getStartDateAsString()) - \(CourseService.shared.getEndDateAsString())",
            for: .normal)
    }
}
