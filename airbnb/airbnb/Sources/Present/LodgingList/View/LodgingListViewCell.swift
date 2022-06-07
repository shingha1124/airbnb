//
//  LodgingListViewCell.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation
import RxSwift
import UIKit

final class LodgingListViewCell: BaseTableViewCell, View {
    private let contentStatckView: UIStackView = {
        let statckView = UIStackView()
        statckView.axis = .vertical
        statckView.spacing = 8
        return statckView
    }()
    
    private let thumbanil: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let rationView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let rationIconView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let rationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .grey1
        return label
    }()
    
    private let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .grey3
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .grey1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .grey1
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .grey3
        return label
    }()
    
    @Inject(\.imageManager) private var imageManager: ImageManager
    
    func bind(to viewModel: LodgingListViewCellModel) {
        
        viewModel.state.updatedRating
            .map { String($0) }
            .bind(to: rationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedReview
            .map { "(후기 \($0)개)" }
            .bind(to: reviewCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedPrice
            .compactMap { $0.convertToKRW() }
            .map { "\($0) / 박" }
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedTotalPrice
            .compactMap { $0.convertToKRW() }
            .map { "총액 \($0)" }
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.updatedThumbnail
            .withUnretained(self)
            .flatMapLatest { vc, url in
                vc.imageManager.loadImage(url: url)
            }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: thumbanil.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.action.loadCellData.accept(())
    }
    
    override func layout() {
        contentView.addSubview(contentStatckView)
        
        contentStatckView.addArrangedSubview(thumbanil)
        contentStatckView.addArrangedSubview(rationView)
        contentStatckView.addArrangedSubview(nameLabel)
        contentStatckView.addArrangedSubview(priceLabel)
        contentStatckView.addArrangedSubview(totalPriceLabel)
        
        rationView.addSubview(rationIconView)
        rationView.addSubview(rationLabel)
        rationView.addSubview(reviewCountLabel)
        
        contentStatckView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(totalPriceLabel)
        }
        
        thumbanil.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumbanil.snp.width).multipliedBy(0.7)
        }
        
        rationView.snp.makeConstraints {
            $0.height.equalTo(rationIconView)
        }

        rationIconView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.width.height.equalTo(18)
        }

        rationLabel.snp.makeConstraints {
            $0.leading.equalTo(rationIconView.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
        }

        reviewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(rationLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentStatckView).offset(24)
        }
    }
}
