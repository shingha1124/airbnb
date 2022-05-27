//
//  CalenderViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import RxDataSources
import RxSwift
import UIKit

final class CheckInOutViewController: UIViewController {
    
    private enum Contants {
        static let cellHeight = 49
        static let headerHeight = 55
    }
    
    private let weekLabelView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        Calendar.current.veryShortWeekdaySymbols.forEach {
            let label = UILabel()
            label.text = $0
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.textColor = .grey3
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CalenderCellView.self, forCellWithReuseIdentifier: CalenderCellView.identifier)
        collectionView.register(CalenderHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalenderHeaderView.identifier)
        
        return collectionView
    }()
    
    private typealias ConfigureCell = (CollectionViewSectionedDataSource<SectionModel<String, CalenderCellViewModel>>, UICollectionView, IndexPath, CalenderCellViewModel) -> UICollectionViewCell
    
    private typealias ConfigureSupplementaryView = (CollectionViewSectionedDataSource<SectionModel<String, CalenderCellViewModel>>, UICollectionView, String, IndexPath) -> UICollectionReusableView
    
    private let viewModel: CheckInOutViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: CheckInOutViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.info("deinit CheckInOutViewController")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.action().viewDidLoad)
            .disposed(by: disposeBag)
        
        let (configureCell, supplementaryView) = collectionViewDataSourceUI()

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CalenderCellViewModel>>(configureCell: configureCell, configureSupplementaryView: supplementaryView)

        viewModel.state().showCalender
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        collectionView.delegate = self
    }
    
    private func layout() {
        view.addSubview(weekLabelView)
        view.addSubview(collectionView)
        
        weekLabelView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(weekLabelView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
}

extension CheckInOutViewController {
    private func collectionViewDataSourceUI() -> (ConfigureCell, ConfigureSupplementaryView) {
        let configureCell: ConfigureCell = { _, collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalenderCellView.identifier, for: indexPath) as? CalenderCellView else {
                return UICollectionViewCell()
            }
            cell.bind(model)
            return cell
        }
        
        let configureSupplementaryView: ConfigureSupplementaryView = { dataSource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalenderHeaderView.identifier, for: indexPath) as? CalenderHeaderView else {
                    return UICollectionReusableView()
                }
                header.setTitle(dataSource[indexPath.section].model)
                return header
            }
            return UICollectionReusableView()
        }
        return (configureCell, configureSupplementaryView)
    }
}

extension CheckInOutViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = Int((collectionView.bounds.width) / CGFloat(7))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        CGSize(width: Int(collectionView.bounds.width), height: Contants.headerHeight)
    }
}
