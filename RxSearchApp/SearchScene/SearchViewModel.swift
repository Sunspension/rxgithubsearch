//
//  SearchViewModel.swift
//  RxSearchApp
//
//  Created by Vladimir Kokhanevich on 09.06.2020.
//  Copyright © 2020 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol SearchViewModel {
    
    func search(query: String) -> Single<[GitHubRepository]>
    func onItemSelected(_ repository: GitHubRepository)
}

class SearchViewModelImplementation {
    
    private let _items = PublishRelay<[GitHubRepository]>()
    private let _api: GitHubClientApi
    
    var router: SearchRouter?
    
    var items: Observable<[GitHubRepository]> {
        return _items.asObservable()
    }
    
    // MARK: Initializer
    
    init(api: GitHubClientApi) {
        
        _api = api
    }
}

extension SearchViewModelImplementation: SearchViewModel {
    
    func search(query: String) -> Single<[GitHubRepository]> {
        
        if query.isEmpty { return .just([]) }
        return _api.request(SearchRepositories(query: query))
            .catchErrorJustReturn([])
    }
 
    func onItemSelected(_ repository: GitHubRepository) {
        
        guard let url = URL(string: repository.url) else { return }
        router?.openWebController(url)
    }
}
