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
                case .All:
                    break
                }
            }
        }
    }
    
    var businessType: BusinessType? {
        didSet {
            
            if let businessType = businessType {
                switch businessType {
                case .Bar:
                    imageView.image = UIImage(named: "bar.png")
                    nameLabel.text = businessType.rawValue
                case .Club:
                    imageView.image = UIImage(named: "club.png")
                    nameLabel.text = businessType.rawValue
                case .Family:
                    imageView.image = UIImage(named: "family.png")
                    nameLabel.text = businessType.rawValue
                case .LiveMusic:
                    imageView.image = UIImage(named: "livemusic.png")
                    nameLabel.text = businessType.rawValue
                case .Outdoors:
                    imageView.image = UIImage(named: "outdoors.png")
                    nameLabel.text = businessType.rawValue
                case .Restaurant:
                    imageView.image = UIImage(named: "restaurant.png")
                    nameLabel.text = businessType.rawValue
                case .None:
                    break
                }
            }
        }
    }
    
    var bandGenre: Genre? {
        didSet {
            
            if let bandGenre = bandGenre {
                imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
                nameLabel.text = ""
                
//                switch bandGenre {
//                case .Rock:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .Blues:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .Jazz:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .Dance:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .Reggae:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .Country:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .FunkSoul:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .EDM:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .HipHop:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .DJ:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .Pop:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .Metal:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .Experimental:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .JamBand:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .Gospel:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                case .EasyListening:
//                    imageView.image = UIImage(named: "\(bandGenre.rawValue.lowercased()).jpg")
//                    nameLabel.text = bandGenre.rawValue
//                }
            }
        }
    }
    
}
