
//
//  WeekTableTableViewController.swift
//  UniPlan
//
//  Created by Student on 2020-08-07.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class WeekPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
//    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let topView = makeTopView(height: UIScreen.main.bounds.height/12)
    let titleLabel = makeLabel(ofSize: 22, weight: .bold)
    var tableView1 = BeforeWeekViewController()
    var tableView2 = WeekTableTableViewController()
    let tableView3 = WeekTableTableViewController()
    let addButton = UIButton()
    var firstSwipe = 0
    var day = TaskService.shared.getfirstDayOfWeek()
    var index = 0
    var isBefore = false
    var isAfter = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView1.tableView.reloadData()
        tableView2.tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Properties
        definesPresentationContext = true
        
        
        //MARK: - UI setup
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        
        topView.addSubview(titleLabel)
        topView.addSubview(addButton)
        view.addSubview(pageViewController.view)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.anchor(left: topView.leftAnchor, paddingLeft: 40)
        titleLabel.text =  "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(6*86400)))"
        titleLabel.textColor = .white
        
        addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: -2).isActive = true
        addButton.anchor(right: topView.rightAnchor, paddingRight: 10)
        addButton.backgroundColor = .clear
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        addButton.setDimensions(width: UIScreen.main.bounds.height/12, height: UIScreen.main.bounds.height/12)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        pageViewController.view.frame = CGRect(x:0, y: UIScreen.main.bounds.height/12+1, width: view.frame.width, height: view.frame.height - self.tabBarHeight)
       
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.setViewControllers([tableView2], direction: .forward, animated: true)
    }
    
    @objc func addButtonPressed() {
        TaskService.shared.setDateOrTime(scIndex: 0)
        TaskService.shared.setReminderDate(date: Date())
        TaskService.shared.setReminderTime([0,0])
        
        let vc = AddTaskViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = BeforeWeekViewController()
        vc.tableView.reloadData()
        tableView1 = vc
        
        isBefore = true
        isAfter = false
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        isAfter = true
        isBefore = false
        
        let vc = WeekTableTableViewController()
        vc.tableView.reloadData()
        tableView2 = vc
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        TaskService.shared.setfirstDayOfWeek(date: day)
        if let before = pendingViewControllers[0] as? BeforeWeekViewController {
            before.tableView.reloadData()
            if tableView1 != before && !isAfter{
                TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400))
            } else {
                TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(-7*86400))
            }
        } else if let after = pendingViewControllers[0] as? WeekTableTableViewController {
            after.tableView.reloadData()
            if tableView2 != after && !isBefore{
                TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(-7*86400))
            } else {
                TaskService.shared.setfirstDayOfWeek(date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400))
            }
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if pageViewController.viewControllers?[0] != previousViewControllers[0] {
            day = TaskService.shared.getfirstDayOfWeek()
            self.titleLabel.text = "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(6*86400)))"
        }
    }
}

