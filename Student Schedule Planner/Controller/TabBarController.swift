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
        let summativesNav = makeNavController(vc: SummativesViewController(), title: "Assessments", image: assignmentImage)
        
        let notesImage = UIImage(named: "notes")
        let notesNav = makeNavController(vc: NotesViewController(), title: "Notes", image: notesImage)
        
        let repeatsImage = UIImage(systemName: "repeat")
        let routinesNav = makeNavController(vc: RoutinesViewController(), title: "Routines", image: repeatsImage)
        
        let tabBarList = [scheduleNav, coursesNav, summativesNav, routinesNav, notesNav]
        tabBar.tintColor = .mainBlue
        viewControllers = tabBarList
    }
    
    func makeNavController(vc: UIViewController, title: String, image: UIImage?) -> UINavigationController{
        vc.navigationItem.title = title
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        navController.isNavigationBarHidden = true
        return navController
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        AllCoursesService.shared.setAddSummative(bool: false)
        AllCoursesService.shared.setAddNote(bool: false)
    }
}

