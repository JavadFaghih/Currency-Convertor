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
    @IBOutlet weak var symbolLabel: UILabel!
    
    var myBallance: Main.Models.ViewModel? {
        didSet {
            myBallanceLabel.text = myBallance?.amount ?? ""
            symbolLabel.text = myBallance?.symbol ?? ""
        }
    }
}
