//
//  SummativesViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-29.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class SummativesViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    //MARK: - Properties
    var tableView = makeTableView(withRowHeight: 50)
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
    let titleLabel = makeTitleLabel(withText: "Summatives")
    let addButton = makeAddButton()
    
    //Non UI
    var pastDueSummatives = [Task]()
    var upcomingSummatives = [Task]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        upcomingSummatives = [Task]()
        pastDueSummatives = [Task]()

        filterSummatives()
        AllCoursesService.shared.setAddSummative(bool: false)
        tableView.reloadData()
    }
    
    func setupViews() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(tableView)
        
        topView.addSubview(titleLabel)
        topView.addSubview(addButton)
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        addButton.anchor(right: topView.rightAnchor, paddingRight: 20)
        addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 5)
        tableView.setDimensions(width: view.frame.width, height: view.frame.height - topView.frame.height)
        tableView.register(TaskCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK: - Actions
    @objc func addButtonTapped() {
        AllCoursesService.shared.setAddSummative(bool: true)
        let vc = CoursesViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    func filterSummatives(){
        let summatives = realm.objects(Task.self).filter("course != %@ AND type != %@", "", "Class")
        for summative in summatives {
            if summative.endDate > Date() {
                upcomingSummatives.append(summative)
            } else {
                pastDueSummatives.append(summative)
            }
        }
    }
    //What happens when you swipe on a cell
    override func updateModel(index: Int, section: Int) {
        do {
            try realm.write {
                var summative = Task()

                switch section {
                case 0:
                    summative = upcomingSummatives[index]
                default:
                    summative = pastDueSummatives[index]
                }
                
                switch summative.type {
                case "assignment":
                    let assignmentToDelete = realm.objects(Assignment.self).filter("index == %@ AND course == %@", summative.index, summative.course).first
                    if let assignmentToDelete = assignmentToDelete {
                        realm.delete(assignmentToDelete)
                    }
                case "quiz":
                    let quizToDelete = realm.objects(Quiz.self).filter("index == %@ AND course == %@", summative.index, summative.course).first
                    if let quizToDelete = quizToDelete {
                        realm.delete(quizToDelete)
                    }
                case "exam":
                    let examToDelete = realm.objects(Exam.self).filter("index == %@ AND course == %@", summative.index, summative.course).first
                    if let examToDelete = examToDelete {
                        realm.delete(examToDelete)
                    }
                default:
                    break
                }
                let taskToDelete = realm.objects(Task.self).filter("id == %@", summative.id)
                realm.delete(taskToDelete)
            }
        } catch {
            print("Error writing to Realm \(error.localizedDescription)")
        }
        upcomingSummatives = [Task]()
        pastDueSummatives = [Task]()

        filterSummatives()
        tableView.reloadData()
    }
}
    //MARK: - Tableview Delegate and Datasource
    extension SummativesViewController: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return upcomingSummatives.count
        default:
            return pastDueSummatives.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let sectionName = makeHeading(withText: "")
        let seperator = makeSpacerView(height: 2)
        
        tableView.backgroundColor = .backgroundColor
        view.addSubview(sectionName)
        view.addSubview(seperator)
        
        sectionName.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 20,paddingLeft: 10)
        
        seperator.backgroundColor = .silver
        seperator.anchor(top: view.topAnchor, paddingTop: 5)
        seperator.setDimensions(width: UIScreen.main.bounds.width - 20)
        seperator.centerX(in: view)
        
        switch section {
        case 0:
            seperator.alpha = 0
            sectionName.text = "Upcoming:"
            if upcomingSummatives.count == 0 {
                let noUpcomingAssignments = makeLabel(ofSize: 20, weight: .semibold)
                view.addSubview(noUpcomingAssignments)
                noUpcomingAssignments.text = "No Upcoming Assignments"
                noUpcomingAssignments.anchor(top: sectionName.bottomAnchor, paddingTop: 10)
                noUpcomingAssignments.centerX(in: view)
            }
        default:
            sectionName.text = "Past Due:"
            if pastDueSummatives.count == 0 {
                let pastDueSummatives = makeLabel(ofSize: 20, weight: .semibold)
                view.addSubview(pastDueSummatives)
                pastDueSummatives.text = "No Past Due Summatives"
                pastDueSummatives.anchor(top: sectionName.bottomAnchor, paddingTop: 10)
                pastDueSummatives.centerX(in: view)
            }
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            if upcomingSummatives.count == 0 {
                return 100
            }
            return 50
        default:
            if pastDueSummatives.count == 0 {
                return 100
            }
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer) as! TaskCell
        switch indexPath.section {
        case 0:
            cell.update(task: upcomingSummatives[indexPath.row], summative: true)
        default:
            cell.update(task: pastDueSummatives[indexPath.row], summative: true)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TaskService.shared.setTaskIndex(index: indexPath.row)
        addButtonTapped()
    }
}


