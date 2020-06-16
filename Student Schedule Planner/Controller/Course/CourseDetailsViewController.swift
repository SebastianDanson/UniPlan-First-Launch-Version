//
//  CourseDetailsViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class CourseDetailsViewController: UIViewController {
    
    let realm = try! Realm()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        classTableView.reloadData()
        assignmentsTableView.reloadData()
        quizzesTableView.reloadData()
        examsTableView.reloadData()
    }
    
    //MARK: - Properties
    //table views
    let classTableView = UITableView()
    let assignmentsTableView = UITableView()
    let quizzesTableView = UITableView()
    let examsTableView = UITableView()
    
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Math")
    
    //Headings
    let classesHeading = makeHeading(withText: "Classes")
    let assignmentsHeading = makeHeading(withText: "Assignments")
    let quizzesHeading = makeHeading(withText: "Quizzes")
    let examsHeading = makeHeading(withText: "Exams")
    
    //Add Buttons
    let classesAddButton = makeAddButtonWithFill()
    let assignmentsAddButton = makeAddButtonWithFill()
    let quizzesAddButton = makeAddButtonWithFill()
    let examsAddButton = makeAddButtonWithFill()
    
    
    
    //MARK: - UISetup
    func setupViews() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(classesHeading)
        view.addSubview(assignmentsHeading)
        view.addSubview(quizzesHeading)
        view.addSubview(examsHeading)
        view.addSubview(classTableView)
        view.addSubview(assignmentsTableView)
        view.addSubview(quizzesTableView)
        view.addSubview(examsTableView)
        view.addSubview(classesAddButton)
        view.addSubview(assignmentsAddButton)
        view.addSubview(quizzesAddButton)
        view.addSubview(examsAddButton)
        
        topView.addSubview(titleLabel)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        //Classes Section
        classesHeading.anchor(top: topView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/55, paddingLeft: 20)
        classesAddButton.anchor(left: classesHeading.rightAnchor, paddingLeft: 7)
        classesAddButton.centerYAnchor.constraint(equalTo: classesHeading.centerYAnchor).isActive = true
        classesAddButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        classTableView.centerX(in: view)
        classTableView.anchor(top: classesHeading.bottomAnchor, paddingTop: 5)
        classTableView.setDimensions(width: view.frame.width, height: 120 )
        classTableView.register(SingleClassCell.self, forCellReuseIdentifier: reuseIdentifer)
        classTableView.delegate = self
        classTableView.dataSource = self
        classTableView.rowHeight = 120
        
        //Assignments Section
        assignmentsHeading.anchor(top: classTableView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/55, paddingLeft: 20)
        assignmentsAddButton.anchor(left: assignmentsHeading.rightAnchor, paddingTop: 15,paddingLeft: 7)
        assignmentsAddButton.centerYAnchor.constraint(equalTo: assignmentsHeading.centerYAnchor).isActive = true
        assignmentsAddButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        assignmentsTableView.centerX(in: view)
        assignmentsTableView.anchor(top: assignmentsHeading.bottomAnchor, paddingTop: 15)
        assignmentsTableView.setDimensions(width: view.frame.width, height: 85)
        assignmentsTableView.register(AssignmentCell.self, forCellReuseIdentifier: reuseIdentifer)
        assignmentsTableView.delegate = self
        assignmentsTableView.dataSource = self
        assignmentsTableView.rowHeight = 85        
        
        //Quizzes Section
        quizzesHeading.anchor(top: assignmentsTableView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/55, paddingLeft: 20)
        quizzesAddButton.anchor(left: quizzesHeading.rightAnchor, paddingLeft: 7)
        quizzesAddButton.centerYAnchor.constraint(equalTo: quizzesHeading.centerYAnchor).isActive = true
        quizzesAddButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        quizzesTableView.centerX(in: view)
        quizzesTableView.anchor(top: quizzesHeading.bottomAnchor, paddingTop: 5)
        quizzesTableView.setDimensions(width: view.frame.width, height: 50)
        quizzesTableView.register(QuizAndExamCell.self, forCellReuseIdentifier: reuseIdentifer)
        quizzesTableView.delegate = self
        quizzesTableView.dataSource = self
        quizzesTableView.rowHeight = 50
        
        //Exams Section
        examsHeading.anchor(top: quizzesTableView.bottomAnchor, left: view.leftAnchor, paddingTop: UIScreen.main.bounds.height/55, paddingLeft: 20)
        examsAddButton.anchor(left: examsHeading.rightAnchor, paddingLeft: 7)
        examsAddButton.centerYAnchor.constraint(equalTo: examsHeading.centerYAnchor).isActive = true
        examsAddButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        examsTableView.centerX(in: view)
        examsTableView.anchor(top: examsHeading.bottomAnchor, paddingTop: 5)
        examsTableView.setDimensions(width: view.frame.width, height: 50)
        examsTableView.register(QuizAndExamCell.self, forCellReuseIdentifier: reuseIdentifer)
        examsTableView.delegate = self
        examsTableView.dataSource = self
        examsTableView.rowHeight = 50
    }
    
    //MARK: - Actions
    @objc func addButtonPressed(button: UIButton) {
        var vc = UIViewController()
        switch button {
        case classesAddButton:
            vc = AddClassViewController()
        case assignmentsAddButton:
            vc = AddAssignmentViewController()
        case quizzesAddButton:
            vc = AddQuizAndExamViewController()
            CourseService.shared.setQuizOrExam(int: 0)
        case examsAddButton:
           vc = AddQuizAndExamViewController()
           CourseService.shared.setQuizOrExam(int: 1)
        default:
            vc = AddQuizAndExamViewController()
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - Tableview Delegate and Datasource
extension CourseDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case classTableView:
            return CourseService.shared.getClasses()?.count ?? 0
        case assignmentsTableView:
            return CourseService.shared.getAssignments()?.count ?? 0
        case quizzesTableView:
            return CourseService.shared.getQuizzes()?.count ?? 0
        case examsTableView:
            return CourseService.shared.getExams()?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case classTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! SingleClassCell
            if let theClass = CourseService.shared.getClass(atIndex: indexPath.row) {
                cell.update(theClass: theClass)
            }
            return cell
            
        case assignmentsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! AssignmentCell
            if let assignment = CourseService.shared.getAssignment(atIndex: indexPath.row) {
                cell.update(assignment: assignment)
            }
            return cell
            
        case quizzesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! QuizAndExamCell
            if let quiz = CourseService.shared.getQuiz(atIndex: indexPath.row) {
                cell.update(quiz: quiz)
            }
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! QuizAndExamCell
            if let exam = CourseService.shared.getExam(atIndex: indexPath.row) {
                cell.update(exam: exam)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AllCoursesService.courseShared.setCourseIndex(index: indexPath.row)
        // addButtonTapped()
    }
}
