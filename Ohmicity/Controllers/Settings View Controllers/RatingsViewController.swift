//
//  RatingsViewController.swift
//  Ohmicity
//
//  Created by Nathan Hedgeman on 9/26/21.
//

import UIKit

class RatingsViewController: UIViewController {
    
    //Properties
    var currentBand: XityBand?
    var currentBusiness: XityBusiness?
    
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    var largeSymbolScaleConfig = UIImage.SymbolConfiguration(scale: .large)
    var givenRating = 0
    var starFilledImage = UIImage()
    var starEmptyImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: UpdateViews
    private func updateViews() {
        guard let currentBand = currentBand else {return}
        guard let starFilledImage = UIImage(systemName: "star.fill", withConfiguration: largeSymbolScaleConfig) else {return}
        self.starFilledImage = starFilledImage
        guard let starEmptyImage = UIImage(systemName: "star", withConfiguration: largeSymbolScaleConfig) else {return}
        self.starEmptyImage = starEmptyImage
        
        ratingsLabel.text = "Give \(currentBand.band.name) a Rating!"
    }
    
    @IBAction func breaker(_ sender: Any) {
        
    }
    
    
    //MARK: Button Actions
    @IBAction func star1ButtonTapped(_ sender: Any) {
        //UI Changes
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starEmptyImage, for: .normal)
        self.star3Button.setImage(starEmptyImage, for: .normal)
        self.star4Button.setImage(starEmptyImage, for: .normal)
        self.star5Button.setImage(starEmptyImage, for: .normal)
        givenRating = 1
        ratingsLabel.text = "1 Star Rating Received"
        
    }
    
    @IBAction func star2ButtonTapped(_ sender: Any) {
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starFilledImage, for: .normal)
        self.star3Button.setImage(starEmptyImage, for: .normal)
        self.star4Button.setImage(starEmptyImage, for: .normal)
        self.star5Button.setImage(starEmptyImage, for: .normal)
        givenRating = 2
        ratingsLabel.text = "2 Star Rating Received"
        
    }
    
    @IBAction func star3ButtonTapped(_ sender: Any) {
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starFilledImage, for: .normal)
        self.star3Button.setImage(starFilledImage, for: .normal)
        self.star4Button.setImage(starEmptyImage, for: .normal)
        self.star5Button.setImage(starEmptyImage, for: .normal)
        givenRating = 3
        ratingsLabel.text = "3 Star Rating Received"
        
    }
    
    @IBAction func star4ButtonTapped(_ sender: Any) {
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starFilledImage, for: .normal)
        self.star3Button.setImage(starFilledImage, for: .normal)
        self.star4Button.setImage(starFilledImage, for: .normal)
        self.star5Button.setImage(starEmptyImage, for: .normal)
        givenRating = 4
        ratingsLabel.text = "4 Star Rating Received"
        
    }
    
    @IBAction func star5ButtonTapped(_ sender: Any) {
        self.star1Button.setImage(starFilledImage, for: .normal)
        self.star2Button.setImage(starFilledImage, for: .normal)
        self.star3Button.setImage(starFilledImage, for: .normal)
        self.star4Button.setImage(starFilledImage, for: .normal)
        self.star5Button.setImage(starFilledImage, for: .normal)
        givenRating = 5
        ratingsLabel.text = "5 Star Rating Received"
        
    }
    
    @IBAction func addRatingButtonTapped(_ sender: Any) {
        if currentBand != nil {
            if givenRating != 0 {
                print("Rating Creating")
                let userRating = UsersRatings(bandName: currentBand?.band.name ?? "testBand", rating: givenRating)
                let bandRating = BandsRatings(bandName: currentBand?.band.name ?? "testBand", userID: currentUserController.currentUser!.userID, stars: givenRating)
                
                if currentUserController.currentUser?.bandRatings == nil {
                    currentUserController.currentUser?.bandRatings = []
                    currentUserController.currentUser?.bandRatings?.append(userRating)
                    do {
                        try FireStoreReferenceManager.bandsRatingsDataPath.document(bandRating.bandsRatingsID).setData(from: bandRating)
                        self.dismiss(animated: true, completion: nil)
                    } catch (let error) {
                        NSLog(error.localizedDescription)
                    }
                } else {
                    currentUserController.currentUser?.bandRatings?.append(userRating)
                    do {
                        try FireStoreReferenceManager.bandsRatingsDataPath.document(bandRating.bandsRatingsID).setData(from: bandRating)
                        self.dismiss(animated: true, completion: nil)
                    } catch (let error) {
                        NSLog(error.localizedDescription)
                    }
                }
            } else {
                ratingsLabel.text = "Please add a rating for \(currentBand?.band.name ?? "this band")"
            }
        } else {
            if givenRating != 0 {
                print("Rating Creating")
                let userRating = UsersRatings(bandName: currentBand?.band.name ?? "testBand", rating: givenRating)
                let bandRating = BandsRatings(bandName: currentBand?.band.name ?? "testBand", userID: currentUserController.currentUser!.userID, stars: givenRating)
                
                if currentUserController.currentUser?.bandRatings == nil {
                    currentUserController.currentUser?.bandRatings = []
                    currentUserController.currentUser?.bandRatings?.append(userRating)
                    do {
                        try FireStoreReferenceManager.bandsRatingsDataPath.document(bandRating.bandsRatingsID).setData(from: bandRating)
                    } catch (let error) {
                        NSLog(error.localizedDescription)
                    }
                } else {
                    currentUserController.currentUser?.bandRatings?.append(userRating)
                    do {
                        try FireStoreReferenceManager.bandsRatingsDataPath.document(bandRating.bandsRatingsID).setData(from: bandRating)
                    } catch (let error) {
                        NSLog(error.localizedDescription)
                    }
                }
            } else {
                ratingsLabel.text = "Please add a rating for \(currentBand?.band.name ?? "this band")"
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
