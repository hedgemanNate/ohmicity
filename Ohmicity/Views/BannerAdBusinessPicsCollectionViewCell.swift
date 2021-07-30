//
//  BannerAdCollectionViewCell.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/28/21.
//

import UIKit

class BannerAdBusinessPicsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var bannerImage: UIImageView!
    
    var bannerAd: BannerAd? {
        didSet {
            if let bannerAd = bannerAd {
                if bannerAd.imageData != nil {
                    bannerImage.image = UIImage(data: bannerAd.imageData!)
                } else {
                    bannerImage.image = bannerAd.image
                }
            }
        }
    }
}
