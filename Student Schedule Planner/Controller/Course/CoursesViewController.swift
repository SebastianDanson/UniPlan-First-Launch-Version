//
//  CoursesViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CoursesViewController: SwipeViewController {
    
    let realm = try! Realm()
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Properties
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
    let titleLabel = makeTitleLabel(withText: "Courses")
    let addButton = makeAddButton()
    let tableView = makeTableView(withRowHeight: 80)
    
    //MARK: - UI setup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(tableView)
        
        topView.addSubview(titleLabel)
        topView.addSubview(addButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        addButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 5)
        tableView.setDimensions(width: view.frame.width, height: view.frame.height - topView.frame.height)
        tableView.register(CourseCell.self, forCellReuseIdentifier: courseReuseIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
        
        if AllCoursesService.shared.getAddSummative() {
            titleLabel.text = "Select Course"
            addButton.isHidden = true
        }
    }
    //What happens when user tries to delete course
    override func updateModel(index: Int, section: Int) {
        
        let alert = UIAlertController(title: "Are You Sure You Want To Delete This Course?", message: "All classes, exams, quizzes, and assignments associated with this class will also be deleted", preferredStyle: .alert)
        let actionDeleteCourse = UIAlertAction(title: "Delete", style: .default) { (alert) in
            do {
                try self.realm.write {
                    if let courseToDelete = AllCoursesService.shared.getCourse(atIndex: index) {
                        AllCoursesService.shared.setCourseIndex(index: nil)
                        let tasksToUpDelete = self.realm.objects(Task.self).filter("course == %@", courseToDelete.title)
                        let assignmentsToDelete = self.realm.objects(Assignment.self).filter("course == %@", courseToDelete.title)
                        let classesToDelete = self.realm.objects(SingleClass.self).filter("course == %@", courseToDelete.title)
                        let examsToDelete = self.realm.objects(Exam.self).filter("course == %@", courseToDelete.title)
                        let quizzesToDelete = self.realm.objects(Quiz.self).filter("course == %@", courseToDelete.title)
                        
                        for assignment in assignmentsToDelete {
                            self.realm.delete(assignment)
                        }
                        
                        for theClass in classesToDelete {
                            self.realm.delete(theClass)
                        }
                        
                        for quiz in quizzesToDelete {
                            self.realm.delete(quiz)
                        }
                        
                        for exam in examsToDelete {
                            self.realm.delete(exam)
                        }
                        
                        for task in tasksToUpDelete {
                            self.realm.delete(task)
                        }
                        
                        self.realm.delete(courseToDelete)
                        AllCoursesService.shared.updateCourses()
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Error writing task to realm")
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in self.tableView.reloadData()}
        
        alert.addAction(actionCancel)
        alert.addAction(actionDeleteCourse)
        present(alert, animated: true)
    }
    
    //MARK: - Actions
    @objc func addButtonPressed() {
        let vc = AddCourseViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

//MARK: - Tableview Delegate and Datasource
extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllCoursesService.shared.getCourses()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: courseReuseIdentifer) as! CourseCell
        if let course = AllCoursesService.shared.getCourse(atIndex: indexPath.row) {
            cell.update(course: course)
            if !AllCoursesService.shared.getAddSummative() {
                cell.delegate = self
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AllCoursesService.shared.setCourseIndex(index: indexPath.row)
        
        if AllCoursesService.shared.getAddSummative() {
            let vc = SelectSummativeTypeViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
        let vc = CourseDetailsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
}


