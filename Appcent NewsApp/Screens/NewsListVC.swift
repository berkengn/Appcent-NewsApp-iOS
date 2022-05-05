//
//  NewsListVC.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 28.04.2022.
//

import UIKit

class NewsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var keyword: String!
    var page            = 1
    var hasMoreArticles = true
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        return table
    }()
    
    private var viewModels  = [ArticleCellViewModel]()
    private var articles    = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor                = .systemBackground
        navigationItem.backBarButtonItem    = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        view.addSubview(tableView)
        tableView.delegate                  = self
        tableView.dataSource                = self
        getArticles(keyword: keyword, page: page)
    }
    
    func getArticles(keyword: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getArticles(for: keyword, page: page) {[weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let articles):
                if articles.count < 20 { self.hasMoreArticles = false }
                self.viewModels.append(contentsOf: articles.compactMap({
                    ArticleCellViewModel(title: $0.title, body: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? ""))
                }))
                self.articles.append(contentsOf: articles)

                if self.viewModels.isEmpty {
                    let message = "There are no articles for this keyword."
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                break
            case .failure(let error):
                //print(error)
                self.presentNAAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! ArticleCell
        let destVC = ArticleInfoVC()
        destVC.articleImageView.image   = cell.articleImageView.image
        destVC.articleAuthor            = article.author
        destVC.articleTitle             = article.title
        destVC.articleContent           = article.content
        destVC.articlePublishedAt       = article.publishedAt
        destVC.articleUrl               = article.url
        destVC.articleDescription       = article.description
        destVC.keyword                  = keyword
        destVC.page                     = page
        navigationController?.pushViewController(destVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y    //The number of how far we scroll down
        let contentHeight   = scrollView.contentSize.height //Height of our content
        let height          = scrollView.frame.size.height  //Height of the screen size
        
        if offsetY > contentHeight - height {
            guard hasMoreArticles else { return }
            page += 1
            getArticles(keyword: keyword, page: page)
        }
    }
}

