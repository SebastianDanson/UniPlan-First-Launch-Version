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
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Courses")
    let addButton = makeAddButton()
    let tableView = makeTableView()
    
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
        tableView.rowHeight = 100
    }
    //What happens when user tries to delete course
    override func updateModel(index: Int, tableView: UITableView) {
     
        let alert = UIAlertController(title: "Are You Sure You Want To Delete This Course?", message: "", preferredStyle: .alert)
        let actionDeleteCourse = UIAlertAction(title: "Delete", style: .default) { (alert) in
            do {
                try self.realm.write {
                    if let courseToDelete = AllCoursesService.courseShared.getCourse(atIndex: index) {
                        self.realm.delete(courseToDelete)
                        AllCoursesService.courseShared.updateCourses()
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
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Class Name", message: "Write the name of the class below", preferredStyle: .alert)
        let actionAddCourse = UIAlertAction(title: "Add Course", style: .default) { (alert) in
            let newCourse = Course()
            newCourse.title = textField.text ?? "Untitled"
            
            do {
                try self.realm.write {
                    self.realm.add(newCourse, update: .modified)
                    self.tableView.reloadData()
                }
            } catch {
                print("ERROR add course to realm \(error.localizedDescription)")
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField { (alertTextField) in
            textField.placeholder = "Add new Category"
            textField = alertTextField
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionAddCourse)
        present(alert, animated: true)
    }
}

//MARK: - Tableview Delegate and Datasource
extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllCoursesService.courseShared.getCourses()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: courseReuseIdentifer) as! CourseCell
        if let course = AllCoursesService.courseShared.getCourse(atIndex: indexPath.row) {
            cell.update(course: course)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AllCoursesService.courseShared.setCourseIndex(index: indexPath.row)
        let vc = CourseDetailsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


