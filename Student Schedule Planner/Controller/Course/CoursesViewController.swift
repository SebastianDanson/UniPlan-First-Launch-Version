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

/*
 * This VC displays all of the users courses
 */

class CoursesViewController: SwipeNoCompleteViewController {
    
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
    let tableView = UITableView()
    let addButton = makeCornerAddButton()
    
    //MARK: - UI setup
    func setupViews() {
        tableView.isScrollEnabled = true
        tableView.separatorColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = .backgroundColor
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        topView.addSubview(titleLabel)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 5)
        tableView.setDimensions(width: view.frame.width,
                                height: view.frame.height - topView.frame.height - (2 * self.tabBarHeight))
        tableView.register(CourseCell.self, forCellReuseIdentifier: courseReuseIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
        
        addButton.anchor(right: view.rightAnchor,
                                    bottom: view.bottomAnchor,
                                    paddingRight: 10,
                                    paddingBottom: self.tabBarHeight + 10)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        if AllCoursesService.shared.getAddSummative() {
            titleLabel.text = "Select Course"
            addButton.isHidden = true
        }
    }
    //What happens when user tries to delete course
    override func updateModel(index: Int, section: Int) {
        
        //Presents an alert confirming if the user wants to delete the course
        let alert = UIAlertController(title: "Are You Sure You Want To Delete This Course?", message: "All classes, exams, quizzes, and assignments associated with this class will also be deleted", preferredStyle: .alert)
        let actionDeleteCourse = UIAlertAction(title: "Delete", style: .default) { (alert) in
            do {
                try self.realm.write {
                    if let courseToDelete = AllCoursesService.shared.getCourse(atIndex: index) {
                        AllCoursesService.shared.setCourseIndex(index: nil)
                        
                        //Deletes all tasks, assignments, classes, quizzes and exams assoicated with that class
                        let tasksToUpDelete = self.realm.objects(Task.self).filter("courseId == %@", courseToDelete.id)
                        let assignmentsToDelete = self.realm.objects(Assignment.self).filter("courseId == %@", courseToDelete.id)
                        let classesToDelete = self.realm.objects(SingleClass.self).filter("courseId == %@", courseToDelete.id)
                        let examsToDelete = self.realm.objects(Exam.self).filter("courseId == %@", courseToDelete.id)
                        let quizzesToDelete = self.realm.objects(Quiz.self).filter("courseId == %@", courseToDelete.id)
                        
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
                            TaskService.shared.deleteNotification(forTask: task)
                            self.realm.delete(task)
                        }
                        
                        self.realm.delete(courseToDelete)
                        AllCoursesService.shared.updateCourses()
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Error writing task to realm \(error.localizedDescription)")
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in self.tableView.reloadData()}
        
        alert.addAction(actionCancel)
        alert.addAction(actionDeleteCourse)
        present(alert, animated: true)
    }
    
    //MARK: - Actions
    @objc func addButtonPressed() {
        AllCoursesService.shared.setSelectedCourse(course: nil)
        let vc = AddCourseViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func sectionHeaderPressed() {
        AllCoursesService.shared.setSelectedCourse(course: nil)
        let vc = AddNotesViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - Tableview Delegate and Datasource
extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if AllCoursesService.shared.getCourses()?.count == 0 {
            
            //If the user has not added any courses it tells that user so
            let noCoursesLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 150))
            noCoursesLabel.text = "No Courses Added"
            noCoursesLabel.textColor = UIColor.darkBlue
            noCoursesLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            noCoursesLabel.textAlignment = .center
            tableView.tableHeaderView = noCoursesLabel
            tableView.separatorStyle = .none
            return 1
        }
        tableView.tableHeaderView = nil
        if AllCoursesService.shared.getAddNote() {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AllCoursesService.shared.getAddNote() {
            if AllCoursesService.shared.getCourses()?.count == 0 {
                return 0
            }
            switch section {
            case 0:
                return 0
            default:
                return AllCoursesService.shared.getCourses()?.count ?? 0
            }
        }
        return AllCoursesService.shared.getCourses()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if AllCoursesService.shared.getAddNote() {
            if section == 0 {
                return 50
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if AllCoursesService.shared.getAddNote() {
            if section == 0 {
                let view = UIView()
                let subView = UIView()
                let label = makeHeading(withText: "Not for a course")
                let nextImage = UIImage(named: "nextMenuButton")
                let nextImageView = UIImageView(image: nextImage)

                view.backgroundColor = .backgroundColor
                view.setDimensions(width: UIScreen.main.bounds.width, height: 50)
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderPressed))
                view.addGestureRecognizer(gesture)
                
                view.addSubview(subView)
                subView.addSubview(label)
                subView.addSubview(nextImageView)
                
                subView.backgroundColor = .silver
                subView.setDimensions(width: UIScreen.main.bounds.width - 20, height: 50)
                subView.centerX(in: view)
                subView.centerY(in: view)
                subView.layer.cornerRadius = 10
                
                nextImageView.centerY(in: subView)
                nextImageView.anchor(right: subView.rightAnchor, paddingRight:  20)

                label.textColor = .white
                label.centerY(in: view)
                label.anchor(left: view.leftAnchor, paddingLeft: 20)
                
                return view
            }
        }
        return nil
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
        
        let course = AllCoursesService.shared.getSelectedCourse()
        let color = UIColor.init(red: CGFloat(course?.color[0] ?? 0), green: CGFloat(course?.color[1] ?? 0), blue: CGFloat(course?.color[2] ?? 0), alpha: 1)
        
        TaskService.shared.setColor(color: color)
        if AllCoursesService.shared.getAddSummative() {
            if AllCoursesService.shared.getAddNote(){
                let vc = AddNotesViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
            let vc = SelectSummativeTypeViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
        let vc = CourseDetailsViewController()
        vc.modalPresentationStyle = .fullScreen
        if let nav = navigationController{
            nav.pushViewController(vc, animated: true)
        }
    }
}


