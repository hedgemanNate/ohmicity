//
//  PurchaseCollectionViewCell.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/9/21.
//

import UIKit

class PurchaseCollectionViewCell: UICollectionViewCell {
    //Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var icon1ImageView: UIImageView!
    @IBOutlet weak var icon1Label: UILabel!
    @IBOutlet weak var icon2ImageView: UIImageView!
    @IBOutlet weak var icon2Label: UILabel!
    
    //Views
    @IBOutlet weak var wholeViewHolderBG: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        wholeViewHolderBG.layer.cornerRadius = 6
        wholeViewHolderBG.layer.backgroundColor = cc.purchaseCellBGColor.cgColor
        //wholeViewHolderBG.layer.borderWidth = 2
        //wholeViewHolderBG.layer.borderColor = UIColor.white.cgColor
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
    }
    
    var purchaseOption: Subscription? {
        didSet {
            
            titleLabel.text = purchaseOption?.type.rawValue
            descriptionTextView.text = purchaseOption?.description ?? "No Description"
            icon1ImageView.image = purchaseOption?.features[0].image
            icon1Label.text = purchaseOption?.features[0].name
            icon2ImageView.image = purchaseOption?.features[1].image
            icon2Label.text = purchaseOption?.features[1].name
        }
    }
}
