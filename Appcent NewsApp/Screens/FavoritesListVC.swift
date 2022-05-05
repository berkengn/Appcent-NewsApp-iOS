//
//  FavoritesListVC.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 28.04.2022.
//

import UIKit

class FavoritesListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        return table
    }()
    
    private var viewModels  = [ArticleCellViewModel]()
    private var favorites   = [Article]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    private func configureViewController() {
        view.backgroundColor                = .systemBackground
        navigationItem.backBarButtonItem    = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        view.addSubview(tableView)
        tableView.delegate                  = self
        tableView.dataSource                = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        getFavorites()
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
        let favorite = favorites[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! ArticleCell
        let destVC = ArticleInfoVC()
        destVC.articleImageView.image   = cell.articleImageView.image
        destVC.articleAuthor            = favorite.author
        destVC.articleTitle             = favorite.title
        destVC.articleContent           = favorite.content
        destVC.articlePublishedAt       = favorite.publishedAt
        destVC.articleUrl               = favorite.url
        destVC.articleDescription       = favorite.description
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        viewModels.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else { return }
            self.presentNAAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let favorites):
                let mapped: [ArticleCellViewModel] = favorites.compactMap { ArticleCellViewModel(title: $0.title, body: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? "")) }
                self.viewModels = mapped
                self.favorites  = favorites
                
                if self.viewModels.isEmpty {
                    let message = "Favorites list is empty."
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
             
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                
               

            case .failure(let error):
                self.presentNAAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
