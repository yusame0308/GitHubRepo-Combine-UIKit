//
//  MainViewModel.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

import Foundation
import Combine

protocol MainViewModelable {
    var listSubject: CurrentValueSubject<[GitHubRepo], Never> { get }
    var isLoadingSubject: PassthroughSubject<Bool, Never> { get }
    var showWebViewSubject: PassthroughSubject<URL, Never> { get }
    var errorAlertSubject: PassthroughSubject<String, Never> { get }
    func fetch(query: String?) async
    func handleDidSelectRowAt(_ indexPath: IndexPath)
}

final class MainViewModel {
    
    var listSubject = CurrentValueSubject<[GitHubRepo], Never>([])
    var isLoadingSubject = PassthroughSubject<Bool, Never>()
    var showWebViewSubject = PassthroughSubject<URL, Never>()
    var errorAlertSubject = PassthroughSubject<String, Never>()
    
    private let apiClient: APIClientable
    
    convenience init() {
        self.init(apiClient: APIClient())
    }
    
    init(apiClient: APIClientable) {
        self.apiClient = apiClient
    }
    
    @MainActor private func setupLoading(_ isLoading: Bool) {
        isLoadingSubject.send(isLoading)
    }
    
    @MainActor private func setupList(_ list: [GitHubRepo]) {
        listSubject.send(list)
        // 追加していくこともできる
        // listSubject.send(listSubject.value + Array(list[...2]))
    }
    
    @MainActor private func showErrorAlert(_ message: String) {
        errorAlertSubject.send(message)
    }
    
}

extension MainViewModel: MainViewModelable {
    
    func fetch(query: String?) async {
        do {
            guard let query = query else { return }
            await setupLoading(true)
            
            let list = try await apiClient.fetchGitHubRepo(query: query).items
            await setupList(list)
            
            await setupLoading(false)
        } catch {
            await setupLoading(false)
            guard let error = error as? APIError else { return }
            await showErrorAlert(error.localizedDescription)
        }
    }
    
    func handleDidSelectRowAt(_ indexPath: IndexPath) {
        let item = listSubject.value[indexPath.row]
        guard let url = URL(string: item.htmlUrl) else { return }
        showWebViewSubject.send(url)
    }
    
}
