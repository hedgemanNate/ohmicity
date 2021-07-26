//
//  CitiesCollectionViewCell.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/23/21.
//

import UIKit

class CitiesCollectionViewCell: UICollectionViewCell {
    
    //Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    var city: City? {
        didSet {
            self.clipsToBounds = true
            self.layer.cornerRadius = 10
            
            if let city = city {
                switch city {
                case .Sarasota:
                    imageView.image = UIImage(named: "sarasota.png")
                    nameLabel.text = city.rawValue
                case .Bradenton:
                    imageView.image = UIImage(named: "bradenton.png")
                    nameLabel.text = city.rawValue
                case .Venice:
                    imageView.image = UIImage(named: "venice.png")
                    nameLabel.text = city.rawValue
                case .StPete:
                    imageView.image = UIImage(named: "stpete.png")
                    nameLabel.text = city.rawValue
                case .Tampa:
                    imageView.image = UIImage(named: "tampa.png")
                    nameLabel.text = city.rawValue
                case .Ybor:
                    imageView.image = UIImage(named: "ybor.png")
                    nameLabel.text = city.rawValue
                }
            }
        }
    }
    
    var type: BusinessType? {
        didSet {
            self.clipsToBounds = true
            self.layer.cornerRadius = 10
            
            if let type = type {
                switch type {
                case .Bar:
                    imageView.image = UIImage(named: "bar.png")
                    nameLabel.text = type.rawValue
                case .Club:
                    imageView.image = UIImage(named: "club.png")
                    nameLabel.text = type.rawValue
                case .Family:
                    imageView.image = UIImage(named: "family.png")
                    nameLabel.text = type.rawValue
                case .LiveMusic:
                    imageView.image = UIImage(named: "livemusic.png")
                    nameLabel.text = type.rawValue
                case .Outdoors:
                    imageView.image = UIImage(named: "outdoors.png")
                    nameLabel.text = type.rawValue
                case .Restaurant:
                    imageView.image = UIImage(named: "restaurant.png")
                    nameLabel.text = type.rawValue
                }
            }
        }
    }
    
}
