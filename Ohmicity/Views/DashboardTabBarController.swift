//
//  DashboardTabBarController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/14/21.
//

import Foundation
import UIKit


class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //Properties
    var menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        self.delegate = self
        self.selectedIndex = 1
        
    }
    
    
     func setupMiddleButton() {
        let menuButtonSquareSize: CGFloat = 70
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 45
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame

        menuButton.backgroundColor = cc.tabBarButtonPurple
        menuButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.layer.shadowRadius = 7
        menuButton.layer.shadowColor = UIColor.black.cgColor
        menuButton.layer.shadowOpacity = 0.7
        view.addSubview(menuButton)

        menuButton.setImage(UIImage(named: "dashboardActive.png"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        //Constraints
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor),
            menuButton.heightAnchor.constraint(equalToConstant: menuButtonSquareSize),
            menuButton.widthAnchor.constraint(equalToConstant: menuButtonSquareSize)
        ]
        NSLayoutConstraint.activate(constraints)
        
        menuButton.clipsToBounds = true

        view.layoutIfNeeded()
    }


    // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 1
    }
}
