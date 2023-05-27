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
    
    private typealias DataSource = UITableViewDiffableDataSource<Int, GitHubRepo>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, GitHubRepo>
    
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
    
    private let cellID = "cellID"
    private lazy var dataSource = configureDataSource()
    
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
                self?.createSnapshot(with: repos)
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
            .sink { [weak self] message in
                let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &subscriptions)
    }
    
    private func configureDataSource() -> DataSource {
        return UITableViewDiffableDataSource(tableView: repositoryTableView) { [weak self] tableView, indexPath, repo in
            let cell = tableView.dequeueReusableCell(withIdentifier: self!.cellID, for: indexPath) as? RepositoryCell
            cell?.render(repo: repo)
            return cell
        }
    }
    
    private func createSnapshot(with repos: [GitHubRepo]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(repos)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension MainViewController: UITableViewDelegate {
    
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // DataSourceに追加することもできる
        // var snapshot = dataSource.snapshot()
        // snapshot.insertItems([GitHubRepo(fullName: "test", stargazersCount: 1, htmlUrl: "url", owner: GitHubRepoOwner(avatarUrl: ""))], afterItem: viewModel.listSubject.value[1])
        // dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
