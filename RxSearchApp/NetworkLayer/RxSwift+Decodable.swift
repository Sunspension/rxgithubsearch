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

public extension ObservableType where Element == Data {
    
    func map<T: Decodable>(_ type: T.Type, using decoder: JSONDecoder = JSONDecoder()) -> Observable<T> {
        return map { data -> T in try decoder.decode(type, from: data) }
    }
    
    func map<T: Decodable>(_ type: T.Type, keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder()) -> Observable<T> {
        return self.map { data -> T in
            let result: Data
            if let keyPath = keyPath {
                
                guard let json = (try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary)?
                    .value(forKeyPath: keyPath) else { throw "Failed to map data to JSON." }
                guard JSONSerialization.isValidJSONObject(json) else { throw "Failed to map data to JSON." }
                result = try JSONSerialization.data(withJSONObject: json)
            }
            else { result = data }
            return try decoder.decode(type, from: result)
        }
    }
}
