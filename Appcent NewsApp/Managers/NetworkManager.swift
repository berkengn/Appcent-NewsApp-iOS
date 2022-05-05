//
//  NetworkManager.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 28.04.2022.
//

import UIKit

class NetworkManager {
    static let shared           = NetworkManager()
    let apiKey                  = "5a6291e12bfb4725aaaeba6364e1ecc2"
    private let baseURL         = "https://newsapi.org/v2/everything"
    let cache                   = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getArticles(for keyword: String, page: Int, completed: @escaping (Result<[Article], NAError>) -> Void) {
        let endpoint = "\(baseURL)?q=\(keyword)&page=\(page)&apiKey=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidKeyword))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                print("asdasf")
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(APIResponse.self, from: data)
                completed(.success(result.articles))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
