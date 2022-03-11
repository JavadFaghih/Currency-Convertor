//
//  MyBallanceCollectionViewCell.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//

import UIKit

class MyBallanceCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier: String = "MyBallanceCollectionViewCell"

    @IBOutlet weak var myBallanceLabel: UILabel!
    
    var myBallance: String? {
        didSet {
            myBallanceLabel.text = myBallance
        }
    }
    

}
