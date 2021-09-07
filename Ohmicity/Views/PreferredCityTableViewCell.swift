//
//  PreferredCityTableViewCell.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/6/21.
//

import UIKit

class PreferredCityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            checkImage.image = UIImage.init(systemName: "checkmark.circle.fill")
            checkImage.tintColor = .green
        } else {
            checkImage.image = UIImage.init(systemName: "checkmark.circle")
            checkImage.tintColor = .gray
        }
    }
    
    var city: City? {
        didSet {
            switch city {
            case .Bradenton:
                cityImage.image = UIImage(named: "\(city!.rawValue.lowercased()).png")
                cityNameLabel.text = city?.rawValue ?? "None"
            case .Sarasota:
                cityImage.image = UIImage(named: "\(city!.rawValue.lowercased()).png")
                cityNameLabel.text = city?.rawValue ?? "None"
            case .StPete:
                cityImage.image = UIImage(named: "\(city!.rawValue.lowercased()).png")
                cityNameLabel.text = city?.rawValue ?? "None"
            case .Tampa:
                cityImage.image = UIImage(named: "\(city!.rawValue.lowercased()).png")
                cityNameLabel.text = city?.rawValue ?? "None"
            case .Venice:
                cityImage.image = UIImage(named: "\(city!.rawValue.lowercased()).png")
                cityNameLabel.text = city?.rawValue ?? "None"
            case .Ybor:
                cityImage.image = UIImage(named: "\(city!.rawValue.lowercased()).png")
                cityNameLabel.text = city?.rawValue ?? "None"
            case .All:
                cityImage.image = UIImage(named: "loginLogo.png")?.scalePreservingAspectRatio(targetSize: cityImage.frame.size)
                cityNameLabel.text = "See All Cities"
            case .none:
                break
            }
        }
    }

}
