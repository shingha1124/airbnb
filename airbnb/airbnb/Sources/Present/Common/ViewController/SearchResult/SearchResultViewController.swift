//
//  SearchResultView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import RxRelay
import RxSwift
import UIKit

final class SearchResultViewController: BaseViewController, View {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SearchResultCellView.self, forCellReuseIdentifier: SearchResultCellView.identifier)
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: SearchResultViewModel) {
        viewModel.state.updatedSearchResult
            .bind(to: tableView.rx.items(cellIdentifier: SearchResultCellView.identifier, cellType: SearchResultCellView.self)) { _, model, cell in
                cell.bind(to: model)
            }
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
