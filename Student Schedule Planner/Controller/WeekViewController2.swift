//
//  WeekViewController2.swift
//  UniPlan
//
//  Created by Student on 2020-08-07.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit
import RealmSwift

class WeekViewController2: UIViewController {
    
    let realm = try! Realm()
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    //MARK: - Properties
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let topView = makeTopView(height: UIScreen.main.bounds.height/15)
    let titleLabel = makeLabel(ofSize: 24, weight: .bold)
    let tableView = WeekTableTableViewController(style: .grouped, date: TaskService.shared.getfirstDayOfWeek())
    let addButton = UIButton()
    
    //MARK: - UI setup
    func setupViews() {

        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        view.addSubview(pageViewController.view)
                
        topView.addSubview(titleLabel)
        topView.addSubview(addButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.anchor(left: topView.leftAnchor, paddingLeft: 40)
        titleLabel.text =  "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400)))"
        titleLabel.textColor = .white
        
        addButton.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        addButton.anchor(right: topView.rightAnchor, paddingRight: 10)
        addButton.backgroundColor = .clear
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 50, weight: .regular)
        addButton.setDimensions(width: UIScreen.main.bounds.height/10, height: UIScreen.main.bounds.height/10)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
            pageViewController.view.frame = CGRect(x:0, y: UIScreen.main.bounds.height/15, width: view.frame.width, height: view.frame.height - topView.frame.height)
         
        self.pageViewController.dataSource = self
        self.pageViewController.setViewControllers([tableView], direction: .forward, animated: true)
    }
    
    @objc func addButtonPressed() {
        TaskService.shared.setDateOrTime(scIndex: 0)
        TaskService.shared.setReminderDate(date: Date())
        TaskService.shared.setReminderTime([0,0])
        
        let vc = AddTaskViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension WeekViewController2: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(-7*86400))
        titleLabel.text =  "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400)))"
        print(TaskService.shared.getfirstDayOfWeek())
        let vc = WeekTableTableViewController(style: .grouped, date: TaskService.shared.getfirstDayOfWeek())
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400))
        titleLabel.text =  "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400)))"
        print("\(TaskService.shared.getfirstDayOfWeek())Yo")
        

        let vc = WeekTableTableViewController(style: .grouped, date: TaskService.shared.getfirstDayOfWeek())
        return vc
    }
}
