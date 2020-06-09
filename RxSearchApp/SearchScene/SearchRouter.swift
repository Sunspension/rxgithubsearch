//
//  SearchRouter.swift
//  RxSearchApp
//
//  Created by Vladimir Kokhanevich on 09.06.2020.
//  Copyright © 2020 Vladimir Kokhanevich. All rights reserved.
//

import UIKit

protocol SearchRouter {
    
    func openWebController(_ url: URL)
}

struct SearchRouterImplementation {
    
    private var _controller: UIViewController
    
    private let _router: RoutingClosure
    
    
    // MARK: Initializer
    
    init(_ controller: UIViewController, router: @escaping RoutingClosure) {
        
        _controller = controller
        _router = router
    }
    
}

extension SearchRouterImplementation: SearchRouter {
    
    func openWebController(_ url: URL) {
        
        let controller = _router(.showDetails(item: url))
        _controller.present(controller, animated: true)
    }
}
