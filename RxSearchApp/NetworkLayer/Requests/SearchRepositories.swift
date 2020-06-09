//
//  SearchRepositories.swift
//  RxSearchApp
//
//  Created by Vladimir Kokhanevich on 09.06.2020.
//  Copyright © 2020 Vladimir Kokhanevich. All rights reserved.
//

import Foundation

struct SearchRepositories: APIRequest {
    
    let method: RequestType = .get
    let path: String = "search/repositories"
    let parameters: [String : String]
    
    init(query: String) {
        parameters = ["q": query]
    }
}
