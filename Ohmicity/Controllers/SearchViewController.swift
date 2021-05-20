//
//  SearchViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit
import MaterialComponents
import Firebase

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //Properties
    @IBOutlet weak var searchBar: MDCFilledTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    

    
    private func updateViews() {
        
    }
}

extension SearchViewController {
    //MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
