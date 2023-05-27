//
//  GitHubRepo.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

struct GitHubRepo: Codable, Hashable {
    let fullName: String
    let stargazersCount: Int
    let htmlUrl: String
    let owner: GitHubRepoOwner
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case htmlUrl = "html_url"
        case owner
    }
    
    var stargazerText: String {
        "⭐︎ " + String(stargazersCount)
    }
}

struct GitHubRepoOwner: Codable, Hashable {
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}

struct GitHubRepoList: Codable {
    let items: [GitHubRepo]
}
