//  AddNotes.swift
//  UniPlan
//
//  Created by Student on 2020-07-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

/*
 * This VC allows the user to add, edit, or delete an Assignment
 */
class AddNotesViewController: UIViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        setupViews()
        self.dismissKey()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorRectangle.backgroundColor = TaskService.shared.getColor()
    }
    
    //MARK: - Properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/9.5)
    let titleLabel = makeTitleLabel(withText: "Note")
    let backButton = makeBackButton()
    
    //not topView
    let titleTextField = makeTextField(withPlaceholder: "Title", height: UIScreen.main.bounds.height/44 + 28)
    let textView = UITextView()
    let saveLabelButton = makeSaveLabelButton()
    let colorRectangle = UIButton()
    
    //MARK: - UI Setup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(titleTextField)
        view.addSubview(textView)
        view.addSubview(colorRectangle)
        
        //topView
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.addSubview(saveLabelButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        saveLabelButton.anchor(right: topView.rightAnchor, paddingRight: 25)
        saveLabelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        saveLabelButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        //Not topView
        titleTextField.layer.borderWidth = 3
        titleTextField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleTextField.anchor(left: view.leftAnchor, paddingLeft: 20)
        titleTextField.delegate = self
        
        textView.anchor(top: titleTextField.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 5, paddingBottom: 5)
        
        let titleTextFieldTopAnchor: NSLayoutConstraint = titleTextField.topAnchor.constraint(equalTo: colorRectangle.bottomAnchor, constant: 10)
        let titleTextFieldOtherAnchor: NSLayoutConstraint = titleTextField.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10)
        titleTextFieldTopAnchor.isActive = true
        
        textView.layer.borderColor = UIColor.mainBlue.cgColor
        textView.layer.borderWidth = 2
        textView.backgroundColor = .backgroundColor
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = 5
        
        textView.centerX(in: view)
        textView.setDimensions(width: UIScreen.main.bounds.width - 40)
        
        
        if let note = CourseService.shared.getSelectedNote() {
            titleTextField.text = note.title
            textView.text = note.notes
            
            TaskService.shared.setColor(color: UIColor(red: CGFloat(note.color[0]), green: CGFloat(note.color[1]), blue: CGFloat(note.color[2]), alpha: 1))
        }
        
        colorRectangle.backgroundColor = TaskService.shared.getColor()
        
        colorRectangle.setDimensions(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/18)
        colorRectangle.layer.cornerRadius = 6
        colorRectangle.anchor(top: topView.bottomAnchor, left:  textView.leftAnchor, paddingTop: 10)
        colorRectangle.addTarget(self, action: #selector(colorRectanglePressed), for: .touchUpInside)
        
        colorRectangle.isHidden = false
        
        if AllCoursesService.shared.getSelectedCourse() != nil {
            colorRectangle.isHidden = true
            
            titleTextFieldTopAnchor.isActive = false
            titleTextFieldOtherAnchor.isActive = true
        }
    }
    
    //MARK: - Actions
    @objc func backButtonPressed() {
        if AllCoursesService.shared.getAddNote() {
            let vc = TabBarController()
            vc.selectedIndex = 4
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func colorRectanglePressed() {
        let vc = ColorsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        let note = Note()
        
        if let course = AllCoursesService.shared.getSelectedCourse()  {
            note.course = course.title
        }
        note.title = titleTextField.text ?? "Untitled"
        if note.title == "" {
            note.title = "Untitled"
        }
        note.notes = textView.text
        let rgb = TaskService.shared.getColor().components
        
        note.color[0] = Double(rgb.red)
        note.color[1] = Double(rgb.green)
        note.color[2] = Double(rgb.blue)
        
        do {
            try realm.write {
                if let noteToUpdate = CourseService.shared.getSelectedNote() {
                    noteToUpdate.title = note.title
                    noteToUpdate.notes = note.notes
                    noteToUpdate.color[0] = note.color[0]
                    noteToUpdate.color[1] = note.color[1]
                    noteToUpdate.color[2] = note.color[2]
                    
                } else {
                    realm.add(note)
                    if let course = AllCoursesService.shared.getSelectedCourse() {
                        course.notes.append(note)
                    }
                }
            }
        } catch {
            print("Error saving Note to Realm \(error.localizedDescription)")
        }
        backButtonPressed()
    }
}

//MARK: - TextField Delegate
extension AddNotesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
