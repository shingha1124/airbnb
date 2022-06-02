//
//  SearchResultView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import RxRelay
import RxSwift
import UIKit

final class SearchResultViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SearchResultCellView.self, forCellReuseIdentifier: SearchResultCellView.identifier)
        return tableView
    }()
    
    private let viewModel: SearchResultViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: SearchResultViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.state().updatedSearchResult
            .bind(to: tableView.rx.items(cellIdentifier: SearchResultCellView.identifier, cellType: SearchResultCellView.self)) { _, model, cell in
                cell.bind(to: model)
            }
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
