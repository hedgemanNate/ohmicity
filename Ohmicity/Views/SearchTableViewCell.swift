//
//  SearchTableViewCell.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 8/7/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var xityBandShow: XityShow? {
        didSet {
            if let xityBandShow = xityBandShow {
                
                //Photo
                if xityBandShow.band.photo == nil {
                    showImage.image = UIImage(named: "DefaultBand.png")
                } else {
                    showImage.image = UIImage(data: xityBandShow.band.photo!)
                }
                
                //Labels
                var stringArray = [String]()
                nameLabel.text = xityBandShow.band.name
                secondNameLabel.text = xityBandShow.business.name
                for genre in xityBandShow.band.genre {
                    stringArray.append(genre.rawValue)
                }
                categoryLabel.text = stringArray.joined(separator: ", ")
            }
        }
    }
    
    var xityBusinessShow: XityShow? {
            didSet {
                if let xityBusinessShow = xityBusinessShow {
                    
                    //Photo
                    showImage.image = UIImage(data: xityBusinessShow.business.logo!)
                   
                    //Labels
                    var stringArray = [String]()
                    nameLabel.text = xityBusinessShow.business.name
                    secondNameLabel.text = xityBusinessShow.band.name
                    for businessType in xityBusinessShow.business.businessType {
                        stringArray.append(businessType.rawValue)
                    }
                    categoryLabel.text = stringArray.joined(separator: ", ")
                }
            }
        }

}
