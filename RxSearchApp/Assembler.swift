//
//  Assembler.swift
//  RxSearchApp
//
//  Created by Vladimir Kokhanevich on 09.06.2020.
//  Copyright © 2020 Vladimir Kokhanevich. All rights reserved.
//

import UIKit
import SafariServices

typealias RoutingClosure = (_ type: AppControllerType) -> UIViewController

enum AppControllerType {
    
    case root, showDetails(item: URL)
}

protocol Assembler {
    
    func controller(type: AppControllerType) -> UIViewController
}

class AssemblerImplementation: Assembler {
    
    // MARK: - Protocol implementation
    
    func controller(type: AppControllerType) -> UIViewController {
        
        switch type {
            
        case .root:
            
            let api = GitHubClientApi()
            let viewModel = SearchViewModelImplementation(api: api)
            let controller = SearchViewController(viewModel)
            viewModel.router = SearchRouterImplementation(controller) { self.controller(type: $0) }
            let navigation = UINavigationController(rootViewController: controller)
            navigation.view.backgroundColor = .white
            return navigation
            
        case .showDetails(let item):
            
            let controller = SFSafariViewController(url: item)
            return controller
        }
    }
}
