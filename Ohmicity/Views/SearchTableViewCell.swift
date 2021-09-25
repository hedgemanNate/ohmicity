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
    
    
    var xityBand: XityBand? {
        didSet {
            if let xityBand = xityBand {
                
                //Photo
                if xityBand.band.photo == nil {
                    showImage.image = UIImage(named: "DefaultBand.png")
                } else {
                    showImage.image = UIImage(data: xityBand.band.photo!)
                }
                
                //Labels
                var stringArray = [String]()
                nameLabel.text = xityBand.band.name
                secondNameLabel.text = "Next Show: \(xityBand.xityShows?.first?.show.venue ?? "None Scheduled")"
                for genre in xityBand.band.genre {
                    stringArray.append(genre.rawValue)
                }
                categoryLabel.text = stringArray.joined(separator: ", ")
            }
        }
    }
    
    var xityBusiness: XityBusiness? {
            didSet {
                if let xityBusiness = xityBusiness {
                    
                    //Photo
                    showImage.image = UIImage(data: xityBusiness.business.logo)
                   
                    //Labels
                    var stringArray = [String]()
                    nameLabel.text = xityBusiness.business.name
                    secondNameLabel.text = "Next Show: \(xityBusiness.xityShows.first?.show.band ?? "None Scheduled")"
                    for businessType in xityBusiness.business.businessType {
                        stringArray.append(businessType.rawValue)
                    }
                    categoryLabel.text = stringArray.joined(separator: ", ")
                }
            }
        }

}
