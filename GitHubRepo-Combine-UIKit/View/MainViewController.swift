//
//  MainViewController.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

import UIKit
import SnapKit
import Combine

final class MainViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "検索"
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
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.color = .white
        indicator.backgroundColor = .systemGray
        indicator.layer.cornerRadius = 5.0
        indicator.layer.opacity = 0.8
        indicator.isHidden = true
        return indicator
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
        view.addSubview(indicator)
        
        repositoryTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RepositoryCell
        
        let repo = repos[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "person")
        cell.textLabel?.text = repo
        cell.detailTextLabel?.text = "detail"
        return cell
    }
    
}
