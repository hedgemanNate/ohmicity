//
//  BandVenueCollectionViewCell.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/14/21.
//

import UIKit

class BandVenueCollectionViewCell: UICollectionViewCell {
    
    //Properties
    @IBOutlet private weak var logoImageView: UIImageView!
    //@IBOutlet private weak var borderImageView: UIImageView!
    //@IBOutlet private weak var ohmPickImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        //super.prepareForReuse()
        logoImageView.image = nil
        //ohmPickImageView.image = nil
        nameLabel.text = nil
    }
    
    var venue: BusinessFullData? {
        didSet {
            if let venue = venue {
                //logoImageView.contentMode = .scaleToFill
                //logoImageView.contentMode = .center
                
                logoImageView.image = UIImage(data: venue.logo!)
                nameLabel.text = venue.name
                
                if venue.ohmPick == true {
                    //ohmPickImageView.image = UIImage(named: "OhmPick")
                }
            }
        }
    }
    
    var band: Band? {
        didSet {
            if let band = band {
                //logoImageView.contentMode = .scaleAspectFill
                //logoImageView.contentMode = .center
                
                logoImageView.image = UIImage(data: band.photo!)
                //nameLabel.text = band.name
                
                if band.ohmPick == true {
                    //ohmPickImageView.image = UIImage(named: "OhmPick")
                }
            }
        }
    }
    
    
}
