//
//  MainViewController.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "検索"
        controller.searchBar.tintColor = .systemMint
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    private lazy var repositoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: cellID)
        return tableView
    }()
    
    let repos = ["aaa", "bbb", "ccc"]
    private let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "GitHubRepo"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(repositoryTableView)
        
        repositoryTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RepositoryCell
        
//        let repo = repos[indexPath.row]
//        cell.text = repo
        return cell
    }
    
}
