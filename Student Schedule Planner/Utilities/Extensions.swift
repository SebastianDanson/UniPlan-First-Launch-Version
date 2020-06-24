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
    static let mainBlue = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
    static let darkBlue = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
    static let clouds = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
    static let turquoise = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1)
    static let emerald = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
    static let riverBlue = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
    static let amethyst = UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1)
    static let midnightBlue = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
    static let sunflower = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
    static let carrot = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
    static let alizarin = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
    static let silver = UIColor(red: 178/255, green: 190/255, blue: 195/255, alpha: 1)
    static let darkGray = UIColor(red: 99/255, green: 110/255, blue: 114/255, alpha: 1)
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
        self.setTitleColor(.backgroundColor, for: .normal)
        self.backgroundColor = .mainBlue
        self.layer.borderColor = UIColor.mainBlue.cgColor
        self.layer.borderWidth = 2
    }
    
    func unhighlight() {
        self.setTitleColor(.mainBlue, for: .normal)
        self.layer.borderColor = UIColor.mainBlue.cgColor
        self.layer.borderWidth = 2
        self.backgroundColor = .clear
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
