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
                
                if xityBand.xityShows.first != nil {
                    let venueID = xityBand.xityShows.first?.business.venueID
                    let venueName = businessController.businessArray.first(where: {$0.venueID == venueID})?.name
                    secondNameLabel.text = "Next Show: \(venueName ?? "None Scheduled")"
                } else {
                    secondNameLabel.text = "None Scheduled"
                }
                
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
                    
                    
                    if xityBusiness.xityShows.first != nil {
                        let bandID = xityBusiness.xityShows.first?.band.bandID
                        let bandName = bandController.bandArray.first(where: {$0.bandID == bandID})?.name
                        secondNameLabel.text = "Next Show: \(bandName ?? "None Scheduled")"
                    } else {
                        secondNameLabel.text = "None Scheduled"
                    }
                    
                    for businessType in xityBusiness.business.businessType {
                        stringArray.append(businessType.rawValue)
                    }
                    categoryLabel.text = stringArray.joined(separator: ", ")
                }
            }
        }

}
