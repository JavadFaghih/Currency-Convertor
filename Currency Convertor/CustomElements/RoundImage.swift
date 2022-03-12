//
//  RoundButton.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//

import UIKit

class RoundImage: UIImageView {
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commenInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func commenInit() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2

    }
}
