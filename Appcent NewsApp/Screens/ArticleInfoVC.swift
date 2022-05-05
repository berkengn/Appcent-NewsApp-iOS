//
//  ArticleInfoVC.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 1.05.2022.
//

import UIKit

class ArticleInfoVC: UIViewController {
    
    var keyword: String?
    var page            = 1
    var hasMoreArticles = true
    
    private var viewModels  = [ArticleCellViewModel]()
    private var favorites   = [Article]()

    
    var articleTitle: String!
    var articleDescription: String!
    var articleAuthor: String?
    var articleContent: String!
    var articleUrlToImage: String!
    var articlePublishedAt: String!
    var articleUrl: String!
    
    let contentView         = UIView()
    let articleImageView    = NAArticleImageView(frame: .zero)
    let titleLabel          = NATitleLabel(textAlignment: .left, fontSize: 22, lineBreakMode: .byWordWrapping)
    let articleLabel        = NABodyLabel(textAlignment: .left)
    let authorImageView     = UIImageView()
    let calendarImageView   = UIImageView()
    let authorNameLabel     = NASecondaryTitleLabel(fontSize: 18)
    let dateLabel           = NASecondaryTitleLabel(fontSize: 18)
    let sourceButton        = NAButton(backgroundColor: .systemPink, title: "News Source")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupContentView()
        addSubviews()
        layoutUI()
        configureUIElements()
        configureSourceButton()
        configureNavigationBar()
    }
    
    func configureUIElements() {
        titleLabel.text = articleTitle
        articleLabel.text = articleContent
        
        if let author = articleAuthor {
            authorNameLabel.text = author
        } else { authorNameLabel.text = "No Author Info" }
        authorNameLabel.adjustsFontSizeToFitWidth = true
        authorNameLabel.minimumScaleFactor = 0.2
        
        dateLabel.text = articlePublishedAt.convertToDisplayFormat()
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor        = 0.2
        
        authorImageView.image       = UIImage(systemName: "newspaper")
        authorImageView.tintColor   = .systemPink
        
        calendarImageView.image     = UIImage(systemName: "calendar")
        calendarImageView.tintColor = .systemPink
        
    }
    
    func layoutUI() {
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        calendarImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 110),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            articleImageView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),
            
            authorImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            authorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            authorImageView.widthAnchor.constraint(equalToConstant: 25),
            authorImageView.heightAnchor.constraint(equalToConstant: 25),
            
            authorNameLabel.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8),
            authorNameLabel.widthAnchor.constraint(equalToConstant: 160),
            authorNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            calendarImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            calendarImageView.leadingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor, constant: 10),
            calendarImageView.widthAnchor.constraint(equalToConstant: 25),
            calendarImageView.heightAnchor.constraint(equalToConstant: 25),
            
            dateLabel.centerYAnchor.constraint(equalTo: calendarImageView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: calendarImageView.trailingAnchor, constant: 8),
            dateLabel.widthAnchor.constraint(equalToConstant: 160),
            dateLabel.heightAnchor.constraint(equalToConstant: 22),
            
            articleLabel.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 10),
            articleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            articleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            articleLabel.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setupContentView(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        contentView.backgroundColor = .systemBackground
        
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    
    private func configureNavigationBar() {
        let shareButton: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))
        let favoriteButton = UIBarButtonItem.init(image: UIImage(systemName: "star"), style: .done, target: self, action: #selector(favoriteButtonPressed))
        self.navigationItem.rightBarButtonItems = [favoriteButton,shareButton]
    }
    
    @objc func shareButtonPressed() {
        if let url = NSURL(string: articleUrl) {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true)

        }
    }
    
    
    @objc func favoriteButtonPressed() {
        
        if let keyword = keyword {
            showLoadingView()
            NetworkManager.shared.getArticles(for: keyword, page: page) {[weak self] result in
                guard let self = self else { return }
                self.dismissLoadingView()
                switch result {
                case .success(let articles):
                    if articles.count < 20 { self.hasMoreArticles = false }

                    for item in articles {
                        if item.url == self.articleUrl {
                            let favorite = Article(title: item.title, description: item.description, content: item.content, author: item.author, url: item.url, urlToImage: item.urlToImage, publishedAt: item.publishedAt)

                            PersistenceManager.updateWith(favorite: favorite , actionType: .add) { [weak self] error in
                                guard let self = self else { return }

                                guard let error = error else {
                                    self.presentNAAlertOnMainThread(title: "Success", message: "You have successfully favorited this user", buttonTitle: "Ok")
                                    return
                                }
                                self.presentNAAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                            }
                        }

                    }
                    break
                case .failure(let error):
                    //print(error)
                    self.presentNAAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
                    break
                }
            }
        }
        else { self.presentNAAlertOnMainThread(title: "Something went wrong", message: "You have already favorited this article", buttonTitle: "Ok")
            return
        }
    }
    
    func addSubviews() {
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(articleLabel)
        contentView.addSubview(authorImageView)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(calendarImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(sourceButton)
    }
    
    func configureSourceButton() {
        NSLayoutConstraint.activate([
            sourceButton.topAnchor.constraint(equalTo: articleLabel.bottomAnchor, constant: 20),
            sourceButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            sourceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            sourceButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        sourceButton.addTarget(self, action: #selector(pushWebViewVC), for: .touchUpInside)
    }
    
    @objc func pushWebViewVC() {
        let webViewVC           = WebViewVC()
        webViewVC.url           = articleUrl
        webViewVC.sourceTitle   = "News Source"
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
}
