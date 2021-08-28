//
//  BannerAdCollectionViewCell.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 7/28/21.
//

import UIKit

class BannerAdBusinessPicsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var businessPicImage: UIImageView!
    
    private var targetSize: CGSize {
        let width = self.layer.bounds.width
        let height = self.layer.bounds.height
        return CGSize(width: width, height: height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    var bannerAd: BusinessBannerAd? {
        didSet {
            if let bannerAd = bannerAd {
                bannerImage.image = UIImage(data: bannerAd.image)
            }
        }
    }
    
    var businessPic: Data? {
        didSet {
            if let businessPic = businessPic {
                guard let image = UIImage(data: businessPic) else {return NSLog("Image couldn't be decoded: BannerAdBusinessPicsCollectionViewCell: businessPic")}
                //businessPicImage.image = image
                let scaledImage = image.scalePreservingAspectRatio(targetSize: targetSize)
                businessPicImage.image = scaledImage
            }
        }
    }
}
