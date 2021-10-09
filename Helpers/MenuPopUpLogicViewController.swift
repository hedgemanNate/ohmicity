//
//  MenuPopUpLogicViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/26/21.
//

import UIKit

class MenuPopUpLogicViewController: UIViewController {
     
    //Properties
    var menuType: MenuType? {
        didSet {
            if let menuType = menuType {
                print("menu type set: didSet")
                gotToVC(menuType: menuType)
            }
        }
    }
    var band: XityBand?
    var business: XityBusiness?
    var show: XityShow?
    
    let ratingSegue = "RatingSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    private func gotToVC(menuType: MenuType) {
        switch menuType {
        case .Rating:
            print("rating menu type")
            performSegue(withIdentifier: ratingSegue, sender: self)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case ratingSegue:
            guard let destinationVC = segue.destination as? RatingsViewController else {return}
            destinationVC.currentBand = band
            destinationVC.currentBusiness = business
        default:
            break
        }
    }

}


