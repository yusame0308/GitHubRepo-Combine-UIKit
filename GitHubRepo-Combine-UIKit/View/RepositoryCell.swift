//
//  RepositoryCell.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

import UIKit

final class RepositoryCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
