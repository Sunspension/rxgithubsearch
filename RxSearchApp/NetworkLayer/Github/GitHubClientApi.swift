//
//  GitHubClientApi.swift
//  RxSearchApp
//
//  Created by Vladimir Kokhanevich on 09.06.2020.
//  Copyright © 2020 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import RxSwift

struct GitHubClientApi {
    
    private let baseURL = URL(string: "https://api.github.com")!
    
    func request<T: Decodable>(_ request: APIRequest) -> Single<T> {
        
        let urlRequest = request.request(baseURL: baseURL)
        return URLSession.shared.rx
            .data(request: urlRequest)
            .map(T.self, keyPath: "items")
            .observeOn(MainScheduler.instance)
            .asSingle()
    }
}


