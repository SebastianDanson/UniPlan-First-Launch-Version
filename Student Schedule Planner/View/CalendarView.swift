//
//  CalendarView.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

//import UIKit
//import FSCalendar
//
//
//class CalendarView: UIView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupViews() {
//
//        let date1 = dateBox(day: "Mon", num: 1)
//        let date2 = dateBox(day: "Tue", num: 2)
//        let date3 = dateBox(day: "Wed", num: 3)
//        let date4 = dateBox(day: "Thu", num: 4)
//        let date5 = dateBox(day: "Fri", num: 5)
//        let date6 = dateBox(day: "Sat", num: 6)
//        let date7 = dateBox(day: "Sun", num: 7)
//
//        let stack = makeDateStackView()
//        addSubview(stack)
//
//        stack.addArrangedSubview(date1)
//        stack.addArrangedSubview(date2)
//        stack.addArrangedSubview(date3)
//        stack.addArrangedSubview(date4)
//        stack.addArrangedSubview(date5)
//        stack.addArrangedSubview(date6)
//        stack.addArrangedSubview(date7)
//    }
//
//    func dateBox(day: String, num: Int) -> UIView {
//
//        let dateBox = UIView()
//        let dayLabel = makeDateLabel(withText: day)
//        let numLabel = makeDateLabel(withText: String(num))
//
//        dateBox.addSubview(dayLabel)
//        dateBox.addSubview(numLabel)
//
//        dateBox.backgroundColor = .backgroundColor
//        dateBox.setDimensions(width: 50, height: 50)
//        dateBox.layer.cornerRadius = 5
//
//        dayLabel.centerX(in: dateBox)
//        dayLabel.anchor(top: dateBox.topAnchor, paddingTop: 5)
//
//        numLabel.centerX(in: dateBox)
//        numLabel.anchor(top: dayLabel.bottomAnchor, paddingTop: 2)
//
//        return dateBox
//    }
//}
