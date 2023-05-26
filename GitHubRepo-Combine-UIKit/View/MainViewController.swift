//
//  MainViewController.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

import UIKit
import SnapKit
import Combine
import SafariServices

final class MainViewController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.delegate = self
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
        indicator.layer.opacity = 0.7
        indicator.isHidden = true
        return indicator
    }()
    
    var repos = [GitHubRepo]() {
        didSet {
            repositoryTableView.reloadData()
        }
    }
    private let cellID = "cellID"
    
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: MainViewModelable = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
        bind()
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
    
    private func bind() {
        viewModel.listSubject
            .sink { [weak self] repos in
                self?.repos = repos
            }
            .store(in: &subscriptions)
        
        viewModel.isLoadingSubject
            .sink { [weak self] in
                $0
                ? self?.indicator.startAnimating()
                : self?.indicator.stopAnimating()
                self?.indicator.isHidden = !$0
            }
            .store(in: &subscriptions)
        
        viewModel.showWebViewSubject
            .sink { [weak self] in
                let viewController = SFSafariViewController(url: $0)
                self?.present(viewController, animated: true)
            }
            .store(in: &subscriptions)
        
        viewModel.errorAlertSubject
            .sink { [weak self] in
                let alert = UIAlertController(title: "エラー", message: $0, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &subscriptions)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RepositoryCell
        
        cell.render(repo: repos[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.handleDidSelectRowAt(indexPath)
    }
    
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task {
            await viewModel.fetch(query: searchBar.text)
        }
    }
    
}
