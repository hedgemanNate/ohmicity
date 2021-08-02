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
    
    //Day Stack
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    
    //Time Stack
    @IBOutlet weak var monTimeLabel: UILabel!
    @IBOutlet weak var tueTimeLabel: UILabel!
    @IBOutlet weak var wedTimeLabel: UILabel!
    @IBOutlet weak var thuTimeLabel: UILabel!
    @IBOutlet weak var friTimeLabel: UILabel!
    @IBOutlet weak var satTimeLabel: UILabel!
    @IBOutlet weak var sunTimeLabel: UILabel!
    
    
    
    class func instanceFromNib(business: BusinessFullData) -> OperationHoursAlert {
        let view = UINib(nibName: "OperationHoursAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OperationHoursAlert
        view.setupView(business: business)
        return view
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.delegate?.removeAlert(sender: self)
    }
    
    
    private func setupView(business: BusinessFullData) {
        //Present Data
        monTimeLabel.text = business.hours?.monday
        tueTimeLabel.text = business.hours?.tuesday
        wedTimeLabel.text = business.hours?.wednesday
        thuTimeLabel.text = business.hours?.thursday
        friTimeLabel.text = business.hours?.friday
        satTimeLabel.text = business.hours?.saturday
        sunTimeLabel.text = business.hours?.sunday
        
        //Default UI
        monTimeLabel.layer.cornerRadius = 0
        tueTimeLabel.layer.cornerRadius = 0
        wedTimeLabel.layer.cornerRadius = 0
        thuTimeLabel.layer.cornerRadius = 0
        friTimeLabel.layer.cornerRadius = 0
        satTimeLabel.layer.cornerRadius = 0
        sunTimeLabel.layer.cornerRadius = 0
        
        monTimeLabel.clipsToBounds = true
        tueTimeLabel.clipsToBounds = true
        wedTimeLabel.clipsToBounds = true
        thuTimeLabel.clipsToBounds = true
        friTimeLabel.clipsToBounds = true
        satTimeLabel.clipsToBounds = true
        sunTimeLabel.clipsToBounds = true
        
        monLabel.layer.cornerRadius = 0
        tueLabel.layer.cornerRadius = 0
        wedLabel.layer.cornerRadius = 0
        thuLabel.layer.cornerRadius = 0
        friLabel.layer.cornerRadius = 0
        satLabel.layer.cornerRadius = 0
        sunLabel.layer.cornerRadius = 0
           
        monLabel.clipsToBounds = true
        tueLabel.clipsToBounds = true
        wedLabel.clipsToBounds = true
        thuLabel.clipsToBounds = true
        friLabel.clipsToBounds = true
        satLabel.clipsToBounds = true
        sunLabel.clipsToBounds = true
        
        
        
        
        
        
        
        
        //Highlight Day Of Week
        switch timeController.dayOfWeek {
        case "Mon":
            monLabel.backgroundColor = cc.highlightPurple
            monTimeLabel.backgroundColor = cc.highlightPurple
            monLabel.textAlignment = .center
            monTimeLabel.textAlignment = .center
        case "Tue":
            tueLabel.backgroundColor = cc.highlightPurple
            tueTimeLabel.backgroundColor = cc.highlightPurple
            tueLabel.textAlignment = .center
            tueTimeLabel.textAlignment = .center
        case "Wed":
            wedLabel.backgroundColor = cc.highlightPurple
            wedTimeLabel.backgroundColor = cc.highlightPurple
            wedLabel.textAlignment = .center
            wedTimeLabel.textAlignment = .center
        case "Thu":
            thuLabel.backgroundColor = cc.highlightPurple
            thuTimeLabel.backgroundColor = cc.highlightPurple
            thuLabel.textAlignment = .center
            thuTimeLabel.textAlignment = .center
        case "Fri":
            friLabel.backgroundColor = cc.highlightPurple
            friTimeLabel.backgroundColor = cc.highlightPurple
            friLabel.textAlignment = .center
            friTimeLabel.textAlignment = .center
        case "Sat":
            satLabel.backgroundColor = cc.highlightPurple
            satTimeLabel.backgroundColor = cc.highlightPurple
            satLabel.textAlignment = .center
            satTimeLabel.textAlignment = .center
        case "Sun":
            sunLabel.backgroundColor = cc.highlightPurple
            sunTimeLabel.backgroundColor = cc.highlightPurple
            sunLabel.textAlignment = .center
            sunTimeLabel.textAlignment = .center
        default:
            break
        }
    }
}

// MARK: - Delegate
protocol OperationHoursAlertDelegate {
    func removeAlert(sender: OperationHoursAlert)
    //func handleData(name: String, isAllowed: Bool)
}


