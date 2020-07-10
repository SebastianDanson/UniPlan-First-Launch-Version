//
//  ColorsViewController.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-07-09.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

/*
 * This class dispalys all of the color options and allows the user to select one
 */

class ColorsViewController: PickerViewController {
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - properties
    //topView
    let topView = makeTopView(height: UIScreen.main.bounds.height/8)
    let titleLabel = makeTitleLabel(withText: "Choose Color")
    let backButton = makeBackButton()
    
    //Color Views
    
    let colorStackView = makeStackView(withOrientation: .vertical, spacing: 20)
    
    let scrollView = UIScrollView()
    
    //MARK: - setup UI
    func setupViews() {
        let redColorView = makeTriColorView(color1: .lightAlizarin, color2: .alizarin, color3: .darkAlizarin)
        let orangeColorView = makeTriColorView(color1: .lightCarrot, color2: .carrot, color3: .darkCarrot)
        let yellowColorView = makeTriColorView(color1: .lightSunflower, color2: .sunflower, color3: .darkSunflower)
        let greenColorView = makeTriColorView(color1: .lightEmerald, color2: .emerald, color3: .darkEmerald)
        let blueColorView = makeTriColorView(color1: .darkRiverBlue, color2: .lightRiverBlue, color3: .riverBlue)
        let darkBlueColorView = makeTriColorView(color1: .lightMidnightBlue, color2: .midnightBlue, color3: .darkmidnightBlue)
        let turquoiseColorView = makeTriColorView(color1: .lightTurquoise, color2: .turquoise, color3: .darkTurquoise)
        let purpleColorView = makeTriColorView(color1: .amethyst, color2: .darkAmethyst, color3: .lightAmethyst)
        let pinkColorView = makeTriColorView(color1: .mediumPink, color2: .lightPink, color3: .darkPink)
        view.backgroundColor = .backgroundColor
        
        view.addSubview(topView)
        view.addSubview(scrollView)
        scrollView.addSubview(colorStackView)
        
        colorStackView.addArrangedSubview(redColorView)
        colorStackView.addArrangedSubview(orangeColorView)
        colorStackView.addArrangedSubview(yellowColorView)
        colorStackView.addArrangedSubview(greenColorView)
        colorStackView.addArrangedSubview(blueColorView)
        colorStackView.addArrangedSubview(turquoiseColorView)
        colorStackView.addArrangedSubview(pinkColorView)
        colorStackView.addArrangedSubview(purpleColorView)
        colorStackView.addArrangedSubview(darkBlueColorView)
        
        //topView
        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        titleLabel.centerYAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        titleLabel.centerX(in: topView)
        
        backButton.anchor(left: topView.leftAnchor, paddingLeft: 20)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        colorStackView.anchor(top: scrollView.topAnchor, paddingTop: 20)
        colorStackView.centerX(in: scrollView)
        
        scrollView.anchor(top: topView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        let size = CGSize(width: view.bounds.width, height: view.bounds.height*1.2)
        self.scrollView.contentSize = size
        scrollView.isScrollEnabled = true
    }
    
    func makeTriColorView(color1: UIColor, color2: UIColor, color3: UIColor) -> UIStackView {
        let stackView = makeStackView(withOrientation: .horizontal, spacing: 0)
        stackView.distribution = .fillEqually
        
        stackView.setDimensions(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/12)
        
        let square1 = UIButton()
        let square2 = UIButton()
        let square3 = UIButton()
        
        stackView.addArrangedSubview(square1)
        stackView.addArrangedSubview(square2)
        stackView.addArrangedSubview(square3)
        
        square1.clipsToBounds = true
        square1.layer.cornerRadius = 10
        square1.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        square3.clipsToBounds = true
        square3.layer.cornerRadius = 10
        square3.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        square1.backgroundColor = color1
        square2.backgroundColor = color2
        square3.backgroundColor = color3
        
        square1.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        square2.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        square3.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        
        return stackView
    }
    //MARK: - Actions
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func colorButtonTapped(button: UIButton) {
        TaskService.shared.setColor(color: button.backgroundColor ?? .clear)
        dismiss(animated: true, completion: nil)
    }
}
