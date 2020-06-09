//
//  GitHubRepository.swift
//  RxSearchApp
//
//  Created by Vladimir Kokhanevich on 09.06.2020.
//  Copyright © 2020 Vladimir Kokhanevich. All rights reserved.
//

import Foundation

struct GitHubRepository {
    
    let name: String
    let url: String
}

extension GitHubRepository: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        
        case name = "full_name", url = "html_url"
    }
}
