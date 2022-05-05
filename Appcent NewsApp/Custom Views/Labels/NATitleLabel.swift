//
//  NATitleLabel.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 28.04.2022.
//

import UIKit

class NATitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat, lineBreakMode: NSLineBreakMode ) {
        super.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        self.lineBreakMode  = lineBreakMode
        configure()
    }
    
    private func configure() {
        textColor                   = .label  //black on light screen, white on dark screen
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9    //Shrinks down 0.9 at minimum
        numberOfLines               = 0
        translatesAutoresizingMaskIntoConstraints = false

        
    }
}
