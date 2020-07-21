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
    static let backgroundColor = UIColor.white
    static let mainBlue = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
    static let darkBlue = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
    static let clouds = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
    
    static let turquoise = UIColor(red: 0/255, green: 210/255, blue: 211/255, alpha: 1)
    static let darkTurquoise = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1)
    static let lightTurquoise = UIColor(red: 52/255, green: 231/255, blue: 228/255, alpha: 1)
    
    static let lightEmerald = UIColor(red: 11/255, green: 232/255, blue: 129/255, alpha: 1)
    static let emerald = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
    static let darkEmerald = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1)
    
    static let lightRiverBlue = UIColor(red: 46/255, green: 134/255, blue: 222/255, alpha: 1)
    static let riverBlue = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
    static let darkRiverBlue = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
    
    static let darkAmethyst = UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1)
    static let lightAmethyst = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1)
    static let amethyst = UIColor(red: 197/255, green: 108/255, blue: 240/255, alpha: 1)
    
    static let darkmidnightBlue = UIColor(red: 34/255, green: 47/255, blue: 62/255, alpha: 1)
    static let lightMidnightBlue = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
    static let midnightBlue = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
    
    static let darkSunflower = UIColor(red: 225/255, green: 177/255, blue: 44/255, alpha: 1)
    static let sunflower = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
    static let lightSunflower = UIColor(red: 255/255, green: 211/255, blue: 42/255, alpha: 1)
    
    static let lightCarrot = UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
    static let carrot = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
    static let darkCarrot = UIColor(red: 211/255, green: 84/255, blue: 0/255, alpha: 1)
    
    static let lightAlizarin = UIColor(red: 255/255, green: 94/255, blue: 87/255, alpha: 1)
    static let alizarin = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
    static let darkAlizarin = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
    
    static let mediumPink = UIColor(red: 247/255, green: 143/255, blue: 179/255, alpha: 1)
    static let lightPink = UIColor(red: 253/255, green: 121/255, blue: 168/255, alpha: 1)
    static let darkPink = UIColor(red: 232/255, green: 67/255, blue: 147/255, alpha: 1)
    
    static let silver = UIColor(red: 178/255, green: 190/255, blue: 195/255, alpha: 1)
    static let darkGray = UIColor(red: 99/255, green: 110/255, blue: 114/255, alpha: 1)
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
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
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//MARK: - Button
extension UIButton {
    func highlight(courseColor: UIColor? = nil) {
        if let courseColor = courseColor {
            self.setTitleColor(.backgroundColor, for: .normal)
            self.backgroundColor = courseColor
            self.layer.borderColor = courseColor.cgColor
            self.layer.borderWidth = 2
        } else {
            self.setTitleColor(.backgroundColor, for: .normal)
            self.backgroundColor = .mainBlue
            self.layer.borderColor = UIColor.mainBlue.cgColor
            self.layer.borderWidth = 2
        }
    }
    
    func unhighlight(courseColor: UIColor? = nil) {
        if let courseColor = courseColor {
            self.setTitleColor(courseColor, for: .normal)
            self.layer.borderColor = courseColor.cgColor
            self.layer.borderWidth = 2
            self.backgroundColor = .clear
        } else {
            self.setTitleColor(.mainBlue, for: .normal)
            self.layer.borderColor = UIColor.mainBlue.cgColor
            self.layer.borderWidth = 2
            self.backgroundColor = .clear
        }
    }
}

//MARK: - Date
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}


//MARK: -  UIViewController
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

//MARK: - TextField
extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 0, width: 28, height: 26))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 40, height: 28))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

extension UIViewController {
    //Height of tabBar 
    var tabBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
