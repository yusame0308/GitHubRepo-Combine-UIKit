//
//  MockAPIClient.swift
//  GitHubRepo-Combine-UIKitTests
//
//  Created by 小原宙 on 2023/05/27.
//

import Foundation
@testable import GitHubRepo_Combine_UIKit

final class MockAPIClient: APIClientable {
    
    let mockGitHubRepoList: GitHubRepoList = GitHubRepoList(
        items: [GitHubRepo(
            fullName: "testName",
            stargazersCount: 10,
            htmlUrl: "https://www.google.com",
            owner: GitHubRepoOwner(avatarUrl: "https://www.google.com")
        )]
    )
    
    private let isSuccess: Bool
    
    required init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func fetchImageData(url: URL) async throws -> Data {
        if isSuccess {
            return Data()
        } else {
            throw APIError.unknownError
        }
    }
    
    func fetchGitHubRepo(query: String) async throws -> GitHubRepoList {
        if isSuccess {
            return mockGitHubRepoList
        } else {
            throw APIError.unknownError
        }
    }
    
}
