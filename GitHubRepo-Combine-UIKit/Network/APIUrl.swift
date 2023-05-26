//
//  APIUrl.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

import Foundation

struct APIUrl {
    static func gitHubRepo(query: String) -> URL {
        return URL(string: "https://api.github.com/search/repositories?q=\(query)")!
    }
}
