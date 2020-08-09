
//
//  WeekTableTableViewController.swift
//  UniPlan
//
//  Created by Student on 2020-08-07.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class WeekPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let topView = makeTopView(height: UIScreen.main.bounds.height/15)
    let titleLabel = makeLabel(ofSize: 24, weight: .bold)
    let tableView = WeekTableTableViewController(style: .grouped, date: TaskService.shared.getfirstDayOfWeek())
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Properties
        
        
        //MARK: - UI setup
        
        view.backgroundColor = .backgroundColor
        view.addSubview(topView)
        
        topView.addSubview(titleLabel)
        topView.addSubview(addButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.anchor(left: topView.leftAnchor, paddingLeft: 40)
        titleLabel.text =  "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(6*86400)))"
        titleLabel.textColor = .white
        
        addButton.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        addButton.anchor(right: topView.rightAnchor, paddingRight: 10)
        addButton.backgroundColor = .clear
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 50, weight: .regular)
        addButton.setDimensions(width: UIScreen.main.bounds.height/10, height: UIScreen.main.bounds.height/10)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        dataSource = self
        delegate = self
        self.setViewControllers([WeekTableTableViewController(style: .grouped, date: TaskService.shared.getfirstDayOfWeek())], direction: .forward, animated: true)
        self.view.frame = CGRect(x:0, y: UIScreen.main.bounds.height/15, width: view.frame.width, height: view.frame.height - UIScreen.main.bounds.height/15)
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
        
        
        
        let vc = WeekTableTableViewController(style: .grouped, date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(-7*86400))
        print(TaskService.shared.getfirstDayOfWeek())
        //titleLabel.text =  "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(-7*86400)))"

        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //titleLabel.text =  "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400)))"
        
        
        let vc = WeekTableTableViewController(style: .grouped, date: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(7*86400))
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        DispatchQueue.main.async {
            self.titleLabel.text =  "\(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek())) - \(formatDateMonthDay(from: TaskService.shared.getfirstDayOfWeek().addingTimeInterval(6*86400)))"
        }
     
    }
    
   
}

