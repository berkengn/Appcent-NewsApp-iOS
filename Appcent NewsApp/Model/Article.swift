//
//  Article.swift
//  Appcent NewsApp
//
//  Created by Berk Engin on 28.04.2022.
//

import Foundation

struct Article: Codable {
    let title: String
    let description: String?
    let content: String?
    let author: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}
