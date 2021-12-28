//
//  DashboardTabBarController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 5/14/21.
//

import Foundation
import UIKit
import MaterialComponents.MaterialActivityIndicator


class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //Properties
    var menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    let activityIndicator = MDCActivityIndicator()
    var activityIndicatorColors = [cc.highlightBlue, UIColor.yellow, UIColor.systemPurple, UIColor.green, UIColor.orange]
    let hapticGenerator = UISelectionFeedbackGenerator()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        self.delegate = self
        self.selectedIndex = 2 
        hapticGenerator.prepare()
    }
    
    
     func setupMiddleButton() {
        let menuButtonSquareSize: CGFloat = 70
        
        let menuButtonFrame = menuButton.frame

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
        setupProgressView()
        view.layoutIfNeeded()
    }
    
    private func setupProgressView() {
        menuButton.addSubview(activityIndicator)
        activityIndicator.center = menuButton.center
        activityIndicator.radius = 27
        activityIndicator.cycleColors = activityIndicatorColors
        activityIndicator.trackEnabled = true
        activityIndicator.bringSubviewToFront(menuButton)
    }


    // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
        self.hapticGenerator.selectionChanged()
        activityIndicator.startAnimating()
        activityIndicatorColors.shuffle()
        xityShowController.todayShowArray.removeAll(where: {$0.show.date < timeController.threeHoursAgo})
        let temp = xityShowController.todayShowArrayFilter
        xityShowController.todayShowArrayFilter = temp
        activityIndicator.cycleColors = activityIndicatorColors
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.activityIndicator.stopAnimating()

        }
    }
}
