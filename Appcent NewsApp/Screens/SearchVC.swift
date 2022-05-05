//
//  SearchVC.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 28.04.2022.
//

import UIKit

class SearchVC: UIViewController {

    let logoImageView       = UIImageView()
    let searchTextField     = NATextField()
    let callToActionButton  = NAButton(backgroundColor: .systemCyan, title: "Search")
    
    var isKeywordEntered: Bool { return !searchTextField.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDissmissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    func createDissmissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushNewsListVC() {
        guard isKeywordEntered else {
            presentNAAlertOnMainThread(title: "Empty Keyword", message: "Please enter a keyword that you want to look for.", buttonTitle: "Ok")
            return
        }
        let newsListVC      = NewsListVC()
        newsListVC.keyword  = searchTextField.text
        newsListVC.title    = searchTextField.text
        navigationController?.pushViewController(newsListVC, animated: true)
    }
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "news-logo")!
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 250),
            logoImageView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func configureTextField() {
        view.addSubview(searchTextField)
        searchTextField.delegate = self
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushNewsListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushNewsListVC()
        return true
    }
}
