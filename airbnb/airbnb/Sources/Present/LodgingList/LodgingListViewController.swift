//
//  LodgingListViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import RxDataSources
import RxSwift
import UIKit

final class LodgingListViewController: BaseViewController, View {
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let searchCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let lodgingTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(LodgingListViewCell.self, forCellReuseIdentifier: LodgingListViewCell.identifier)
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: LodgingListViewModel) {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, LodgingListViewCellModel>>( configureCell: { ds, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LodgingListViewCell.identifier, for: indexPath) as? LodgingListViewCell else {
                return UITableViewCell()
            }
            
            let model = ds.sectionModels[indexPath.section].items[indexPath.item]
            cell.viewModel = model
            return cell
        })
        
        viewModel.state.updatedLodgingList
            .map {
                [SectionModel(model: "123", items: $0)]
            }
            .bind(to: lodgingTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(lodgingTableView)
        
        lodgingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
