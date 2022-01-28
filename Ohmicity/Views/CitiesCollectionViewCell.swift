//
//  CitiesCollectionViewCell.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/23/21.
//

import UIKit

class CitiesCollectionViewCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.backgroundColor = .clear
        imageView.image = nil
        if self.isSelected == false {
            layer.borderWidth = 0
        } else {
            layer.borderWidth = 2
            layer.borderColor = UIColor.purple.cgColor
        }
    }
    
    //Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    var city: City? {
        didSet {
            
            if let city = city {
                imageView.image = UIImage(named: "\(city.rawValue.lowercased()).png")
                nameLabel.text = city.rawValue
            }
        }
    }
    
    var businessType: BusinessType? {
        didSet {
            
            if let businessType = businessType {
                imageView.image = UIImage(named: "\(businessType.rawValue.lowercased()).png")
                nameLabel.text = businessType.rawValue
            }
        }
    }
    
    var bandGenre: Genre? {
        didSet {
            
            if let bandGenre = bandGenre {
                imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).png")
                nameLabel.text = ""
            } else {
                imageView.image = UIImage(named: "na.png")
                nameLabel.text = ""
            }
        }
    }
    
}
