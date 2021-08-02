//
//  HoursOfOperationAlertViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/1/21.
//

import UIKit

class OperationHoursAlert: UIView {
    
    //Properties
    var delegate: OperationHoursAlertDelegate?
    
    
    //Time Stack
    @IBOutlet weak var monTimeLabel: UILabel!
    @IBOutlet weak var tueTimeLabel: UILabel!
    @IBOutlet weak var wedTimeLabel: UILabel!
    @IBOutlet weak var thuTimeLabel: UILabel!
    @IBOutlet weak var friTimeLabel: UILabel!
    @IBOutlet weak var satTimeLabel: UILabel!
    @IBOutlet weak var sunTimeLabel: UILabel!
    
    
    
    class func instanceFromNib(business: BusinessFullData) -> OperationHoursAlert {
        let view = UINib(nibName: "HoursOfOperationAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OperationHoursAlert
        view.setupView(business: business)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.delegate?.removeAlert(sender: self)
    }
    
    
    
    
    private func setupView(business: BusinessFullData) {
        monTimeLabel.text = business.hours?.monday
        tueTimeLabel.text = business.hours?.tuesday
        wedTimeLabel.text = business.hours?.wednesday
        thuTimeLabel.text = business.hours?.thursday
        friTimeLabel.text = business.hours?.friday
        satTimeLabel.text = business.hours?.saturday
        sunTimeLabel.text = business.hours?.sunday
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}

// MARK: - Delegate
protocol OperationHoursAlertDelegate {
    func removeAlert(sender: OperationHoursAlert)
    //func handleData(name: String, isAllowed: Bool)
}


