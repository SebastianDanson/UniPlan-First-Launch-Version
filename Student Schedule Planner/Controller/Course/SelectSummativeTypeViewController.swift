//
//  SelectSummativeType.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-30.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

enum SummativeType: Int, CustomStringConvertible, CaseIterable{
    
    case Assignment
    case Exam
    case Quiz
    
    var description: String {
        switch self {
        case .Assignment:
            return "Assignment"
        case .Exam:
            return "Exam"
        case .Quiz:
            return "Quiz"
        }
    }
}

/*
 * This VC allows the user to select the type of summative it wants to add
 * It then displays the proper VC depending on which summative was selected
 */
class SelectSummativeTypeViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    //MARK: - Properties
    var tableView = makeTableView(withRowHeight: 50)
    let topView = makeTopView(height: UIScreen.main.bounds.height/8.5)
    let titleLabel = makeTitleLabel(withText: "Select Type")
    let backButton = makeBackButton()
    
    var pastDueSummatives = [Task]()
    var upcomingSummatives = [Task]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.reloadData()
    }
    
    func setupViews() {
        view.backgroundColor = .backgroundColor
        tableView.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(tableView)
        
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        tableView.centerX(in: view)
        tableView.anchor(top: topView.bottomAnchor, paddingTop: 5)
        tableView.setDimensions(width: view.frame.width, height: view.frame.height - topView.frame.height)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Summative")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

// MARK: - Table view data source and delegate
extension SelectSummativeTypeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SummativeType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Summative", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        guard let summativeType = SummativeType(rawValue: indexPath.row) else {return cell}
        cell.textLabel?.text = summativeType.description
        cell.backgroundColor = .backgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = AddAssignmentViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        case 1:
            CourseService.shared.setQuizOrExam(int: 1)
            let vc = AddQuizAndExamViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        case 2:
            CourseService.shared.setQuizOrExam(int: 0)
            let vc = AddQuizAndExamViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        default:
            break
        }
    }
}


