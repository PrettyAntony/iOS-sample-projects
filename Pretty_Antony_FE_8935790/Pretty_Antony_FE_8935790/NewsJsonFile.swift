//
//  NewsJsonFile.swift
//  Pretty_Antony_FE_8935790
//
//  Created by user234138 on 12/7/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newsData = try? JSONDecoder().decode(NewsData.self, from: jsonData)

import Foundation

// MARK: - NewsData
struct NewsData: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title, description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}


