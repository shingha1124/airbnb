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
    
    let lodgingTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
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
        
        viewModel.state.presentDetailView
            .withUnretained(self)
            .bind(onNext: { vc, id in
//                let viewController = DetailViewController(
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(lodgingTableView)
        
        lodgingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

final class IntrinsicTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
      let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
      return CGSize(width: self.contentSize.width, height: height)
    }
    
    override func layoutSubviews() {
      self.invalidateIntrinsicContentSize()
      super.layoutSubviews()
    }
}
