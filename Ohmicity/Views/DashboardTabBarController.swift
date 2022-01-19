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
    static let activityIndicator = MDCActivityIndicator()
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
        menuButton.addSubview(DashboardTabBarController.activityIndicator)
        DashboardTabBarController.activityIndicator.center = menuButton.center
        DashboardTabBarController.activityIndicator.radius = 27
        DashboardTabBarController.activityIndicator.cycleColors = activityIndicatorColors
        DashboardTabBarController.activityIndicator.trackEnabled = true
        DashboardTabBarController.activityIndicator.bringSubviewToFront(menuButton)
    }


    // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        xityShowController.todayShowResultsArray.removeAll(where: {$0.show.date < timeController.threeHoursAgo})
        selectedIndex = 2
        self.hapticGenerator.selectionChanged()
        DashboardTabBarController.activityIndicator.startAnimating()
        activityIndicatorColors.shuffle()
        let temp = xityShowController.todayShowArrayFilter
        xityShowController.todayShowArrayFilter = temp
        DashboardTabBarController.activityIndicator.cycleColors = activityIndicatorColors
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            DashboardTabBarController.activityIndicator.stopAnimating()
        }
    }
}
