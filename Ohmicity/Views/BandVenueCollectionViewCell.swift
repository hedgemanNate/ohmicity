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
    @IBOutlet private weak var borderImageView: UIImageView!
    @IBOutlet private weak var adImageView: UIImageView!
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
    
    var venue: Business? {
        didSet {
            if let venue = venue {
                //logoImageView.contentMode = .scaleToFill
                //logoImageView.contentMode = .center
                
                borderImageView.image = UIImage(named: "BandVenueBorder.png")
                logoImageView.image = UIImage(data: venue.logo)
                nameLabel.text = venue.name
                
                if venue.ohmPick == true {
                    borderImageView.image = UIImage(named: "BandVenueBorderXityPick.png")
                }
                
//                if venue.ad == true {
//                    adImageView.image = UIImage(named: "ad.png")
//                }
            }
        }
    }
    
    var band: Band? {
        didSet {
            if let band = band {
                
                if band.photo != nil {
                logoImageView.image = UIImage(data: band.photo!)
                } else {
                    logoImageView.image = UIImage(named: "DefaultBand.png")
                }
                nameLabel.text = band.name
                
                if band.ohmPick == true {
                    //ohmPickImageView.image = UIImage(named: "OhmPick")
                }
            }
        }
    }
    
    var xityPick: XityShow? {
        didSet {
            if let xityPick = xityPick {
                if xityPick.band.photo == nil {
                    logoImageView.image = UIImage(named: "DefaultBand.png")
                } else {
                    logoImageView.image = UIImage(data: xityPick.band.photo!)
                }
                nameLabel.text = xityPick.band.name
                //ohmPickImageView.image = UIImage(named: "OhmPick")
            }
        }
    }
    
    
}
