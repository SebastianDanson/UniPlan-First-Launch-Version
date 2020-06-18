//
//  Extensions.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-02.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

//MARK: - UIColor
extension UIColor {
    static let backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    static let mainBlue = UIColor(red: 30/255, green: 86/255, blue: 160/255, alpha: 1)
    static let darkBlue = UIColor(red: 34/255, green: 49/255, blue: 63/255, alpha: 1)
    static let lightBlue = UIColor(red: 214/255, green: 228/255, blue: 240/255, alpha: 1)
    static let turquoise = UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
    static let emerald = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
    static let riverBlue = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
    static let amethyst = UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1)
    static let midnightBlue = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)

}
//MARK: - UIView
extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0, paddingBottom: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
    }
    
    func centerX(in view: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(in view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, constant: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        if let leftAnchor = leftAnchor {
            anchor(left: leftAnchor, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

//MARK: - Button
extension UIButton {
    func highlight() {
        self.setTitleColor(.mainBlue, for: .normal)
        self.layer.borderColor = UIColor.mainBlue.cgColor
        self.layer.borderWidth = 2
    }

    func unhighlight() {
        self.setTitleColor(.darkBlue, for: .normal)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
}

//MARK: - Date
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

//MARK: - Dismiss Keyboard
extension UIViewController {
    func dismissKey() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
