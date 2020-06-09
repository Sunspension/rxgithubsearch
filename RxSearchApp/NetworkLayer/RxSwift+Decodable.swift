//
//  RxSwift+Decodable.swift
//  RxSearchApp
//
//  Created by Vladimir Kokhanevich on 09.06.2020.
//  Copyright © 2020 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import RxSwift

extension String: Error {}
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension ObservableType where Element == Data {
    
    func map<T: Decodable>(_ type: T.Type, keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder()) -> Observable<T> {
        
        return map { data -> T in
            
            let result: Data
            if let keyPath = keyPath {
                
                guard let json = (try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary)?
                    .value(forKeyPath: keyPath), JSONSerialization.isValidJSONObject(json) == true else { throw "Failed to map data to JSON." }
                result = try JSONSerialization.data(withJSONObject: json)
            }
            else { result = data }
            
            return try decoder.decode(type, from: result)
        }
    }
}
