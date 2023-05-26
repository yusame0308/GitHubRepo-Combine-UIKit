//
//  RepositoryCell.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

import UIKit

final class RepositoryCell: UITableViewCell {
    
    private let apiClient: APIClientable = APIClient()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(repo: GitHubRepo) {
        textLabel?.text = repo.fullName
        detailTextLabel?.text = repo.stargazerText
        
        guard let url = URL(string: repo.owner.avatarUrl) else { return }
        Task {
            let data = try await apiClient.fetchImageData(url: url)
            setupImage(UIImage(data: data))
        }
    }
    
    @MainActor private func setupImage(_ image: UIImage?) {
        imageView?.image = image
    }
    
}
