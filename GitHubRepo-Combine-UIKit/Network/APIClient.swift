//
//  APIClient.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

import Foundation
import Network

protocol APIClientable {
    func fetchImageData(url: URL) async throws -> Data
    func fetchGitHubRepo(query: String) async throws -> GitHubRepoList
}

final class APIClient: APIClientable {
    
    static var networkStatus: NWPath.Status = .satisfied
    
    func fetchImageData(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.unknownError
        }
        
        return data
    }
    
    func fetchGitHubRepo(query: String) async throws -> GitHubRepoList {
        guard APIClient.networkStatus == .satisfied else {
            throw APIError.networkError
        }
        
        let url = APIUrl.gitHubRepo(query: query)
        debugPrint("Request: " + url.absoluteString)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknownError
        }
        debugPrint("Response Status Code: " + String(httpResponse.statusCode))
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(GitHubRepoList.self, from: data)
        case 401:
            throw APIError.unauthorizedError
        case 503:
            throw APIError.maintenaceError
        default:
            throw APIError.unknownError
        }
    }
    
}
