//
//  ClassTypeTableViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-14.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

enum ClassType: Int, CustomStringConvertible, CaseIterable{
   
    case Class
    case Lecture
    case Lab
    case Tutorial
    case Seminar
    case StudySession
    
    var description: String {
        switch self {
        case .Class:
            return "Class"
        case .Lecture:
            return "Lecture"
        case .Lab:
            return "Lab"
        case .Tutorial:
            return "Tutorial"
        case .Seminar:
            return "Seminar"
        case.StudySession:
            return "Study Session"
        }
    }
}

class ClassTypeViewController: UIViewController {
    
    let realm = try! Realm()
    
    //MARK: - Properties
    var tableView = makeTableView(withRowHeight: 50)
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let backButton = makeBackButton()
    let titleLabel = makeTitleLabel(withText: "Select Class Type")
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TaskService.shared.loadTasks()
        tableView.reloadData()
        TaskService.shared.setDateSelected(date: Date())
        TaskService.shared.setTaskIndex(index: nil)
        TaskService.shared.setReminderTime([0, 0]) //First index is hours, second is minutes
        TaskService.shared.setReminderDate(date: Date())
        TaskService.shared.setDateOrTime(scIndex: 0) //0 means time was selected, non zero means date was selected
        TaskService.shared.setHideReminder(bool: true)
        TaskService.shared.setCheckForTimeConflict(bool: true)
    }
    
    //MARK: - setup UI
    func setupViews() {
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(tableView)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 5)
        tableView.setDimensions(width: view.frame.width, height: view.frame.height - topView.frame.height)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
    // MARK: - Table view data source and delegate
    extension ClassTypeViewController: UITableViewDataSource, UITableViewDelegate {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ClassType.allCases.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
            guard let classType = ClassType(rawValue: indexPath.row) else {return cell}
            
            cell.textLabel?.text = classType.description
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            SingleClassService.shared.setType(classType: ClassType(rawValue: indexPath.row) ?? .Class)
            dismissVC()
        }
}


