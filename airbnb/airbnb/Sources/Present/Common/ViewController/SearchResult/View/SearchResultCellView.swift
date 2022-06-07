//
//  SearchResultCellView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import RxSwift
import UIKit

final class SearchResultCellView: UITableViewCell {
    static let identifier = "SearchResultCellView"
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_mapIcon")
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let addressName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .grey1
        return label
    }()
    
    private let cellButton = UIButton()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layout()
    }
      
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(to viewModel: SearchResultCellViewModelProtocol) {
        viewModel.state().loadedCellData
            .bind(to: addressName.rx.text)
            .disposed(by: disposeBag)
        
        cellButton.rx.tap
            .bind(to: viewModel.action().tappedCell)
            .disposed(by: disposeBag)
        
        viewModel.action().loadCellData.accept(())
    }
    
    private func layout() {
        contentView.addSubview(icon)
        contentView.addSubview(addressName)
        contentView.addSubview(cellButton)
        
        icon.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(7)
            $0.leading.equalToSuperview()
            $0.width.equalTo(64)
        }
        
        addressName.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        cellButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(icon).offset(7)
        }
    }
    
    func setAddress(_ address: String) {
        addressName.text = address
    }
}
