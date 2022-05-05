//
//  ArticleCell.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 30.04.2022.
//

import UIKit



class ArticleCell: UITableViewCell {
    static let identifier   = "ArticleCell"
    let cache               = NetworkManager.shared.cache
    
    private let articleTitleLabel   = NATitleLabel(textAlignment: .left, fontSize: 25, lineBreakMode: .byTruncatingTail)
    private let articleBodyLabel    = NABodyLabel(textAlignment: .left)
    let articleImageView            = NAArticleImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(articleTitleLabel)
        addSubview(articleBodyLabel)
        addSubview(articleImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        articleTitleLabel.frame = CGRect(x: 10, y: 0, width: frame.size.width - 170, height: 70)
        articleBodyLabel.frame  = CGRect(x: 10, y: 70, width: frame.size.width - 170, height: frame.size.height / 2)
        articleImageView.frame  = CGRect(x: frame.size.width - 157, y: 15, width: 150, height: frame.size.height - 30)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: ArticleCellViewModel) {
        articleTitleLabel.text  = viewModel.title
        articleBodyLabel.text   = viewModel.body
        if let urlString = viewModel.imageURL?.absoluteString {
            articleImageView.downloadImage(from: urlString)
        }
    }


}
