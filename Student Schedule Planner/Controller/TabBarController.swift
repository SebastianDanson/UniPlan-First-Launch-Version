//
//  TabBarController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-11.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let calendarImage = UIImage(named: "calendar")
        let scheduleNav = makeNavController(vc: TimelineViewController(), title: "Schedule", image: calendarImage)
        
        let coursesImage = UIImage(named: "courses")
        let coursesNav = makeNavController(vc: CoursesViewController(), title: "Courses", image: coursesImage)
        
        let assignmentImage = UIImage(named: "assignments")
        let summativesNav = makeNavController(vc: TimelineViewController(), title: "Assignments", image: assignmentImage)

        let tabBarList = [scheduleNav, coursesNav, summativesNav]
        tabBar.tintColor = .mainBlue

        //tabBarController.to

        
        viewControllers = tabBarList
   
        // Do any additional setup after loading the view.
    }
    
    func makeNavController(vc: UIViewController, title: String, image: UIImage?) -> UINavigationController{
        vc.navigationItem.title = title
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        navController.isNavigationBarHidden = true
        return navController
    }
}