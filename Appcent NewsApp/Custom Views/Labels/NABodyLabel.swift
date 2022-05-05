//
//  NABodyLabel.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 28.04.2022.
//

import UIKit

class NABodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure() {
        textColor                   = .secondaryLabel //Light grey color
        font                        = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.75    //Shrinks down 0.75 at minimum
        lineBreakMode               = .byWordWrapping  //if the text is too long it will wrap at the end of the last word in line
        numberOfLines               = 0
        translatesAutoresizingMaskIntoConstraints = false
    }

}
