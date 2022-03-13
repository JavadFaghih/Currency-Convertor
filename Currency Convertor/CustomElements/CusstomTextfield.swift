//
//  CusstomTextfield.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//

import UIKit

class CustomTextfield: UITextField {
    
    //MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commeniInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commeniInit()
    }
    
    //MARK: - Methods
    private func commeniInit() {
        self.borderStyle = .none
      //  textAlignment = .right
    }
    
    func setRightTitle(text: String) {
        let view = UIView()
        var viewXPosition: CGFloat {
            get {
                self.frame.size.width * 0.95
            }
        }
        var viewWidth: CGFloat {
            get {
                self.frame.size.width * 0.05
            }
        }
        
        view.frame = CGRect(x: viewXPosition, y: 0, width: viewWidth, height: viewWidth)
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth)
        label.center = view.center
        label.text = text
        label.textAlignment = .right
        view.addSubview(label)
        rightView = view
        rightViewMode = .always
    }
    
    
    func setLeftTitle(text: String) {
        let view = UIView()
        var viewWidth: CGFloat {
            get {
                self.frame.size.width * 0.3
            }
        }
        
        var viewHeight: CGFloat {
            get {
                self.frame.size.height
            }
        }
        
        view.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        label.center = view.center
        label.text = text
        label.textAlignment = .left
        view.addSubview(label)
        leftView = view
        leftViewMode = .always
        
    }
    
    func setRightImage(image: UIImage) {
        
        
        let view = UIView()
        var viewXPosition: CGFloat {
            get {
                self.frame.size.width * 0.97
            }
        }
        var viewWidth: CGFloat {
            get {
                12
            }
        }
        var viewHeight: CGFloat {
            get {
                self.frame.size.height
            }
        }
        
        view.frame = CGRect(x: viewXPosition, y: 0, width: viewWidth, height: viewHeight)
        view.clipsToBounds = true
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        imageView.image = image
        imageView.contentMode = .center
        view.addSubview(imageView)
        rightView = view
        rightViewMode = .always
        
    }
}

