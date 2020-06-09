//
//  SearchViewController.swift
//  RxSearchApp
//
//  Created by Vladimir Kokhanevich on 09.06.2020.
//  Copyright © 2020 Vladimir Kokhanevich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UITableViewController {

    private let _bag = DisposeBag()
    private let _cellIdentifier = "cell"
    
    private lazy var _searchController: UISearchController = {
        
        var controller = UISearchController()
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    private let _viewModel: SearchViewModel
    
    
    // MARK: Initializer
    
    init(_ viewModel: SearchViewModel) {
        
        _viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationController()
        setupTableViewDelegate()
        setupSearchBar()
    }
    
    
    // MARK: Private
    
    private func setupTableView() {
        
        view.backgroundColor = .white
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: _cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.dataSource = nil
        tableView.delegate = nil
    }
    
    private func setupNavigationController() {
        
        navigationItem.searchController = _searchController
        navigationItem.title = "Github Repositories"
    }
    
    private func setupSearchBar() {
        
        _searchController.searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" }
            .flatMapLatest { [weak self] in self?._viewModel.search(query: $0) ?? .just([]) }
            .bind(to: tableView.rx.items(cellIdentifier: _cellIdentifier, cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element.name }
            .disposed(by: _bag)
    }
    
    private func setupTableViewDelegate() {
        
        tableView.rx
            .modelSelected(GitHubRepository.self)
            .subscribe(onNext: { [unowned self] in self._viewModel.onItemSelected($0) })
            .disposed(by: _bag)
    }
}
