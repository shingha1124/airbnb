//
//  MapCollectionCell.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/23.
//

import RxSwift
import SnapKit

final class MapCollectionCell: UICollectionViewCell {
    static var identifier: String { .init(describing: self) }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.backgroundColor = UIColor.blue.cgColor
        return imageView
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "별 4.80 (후기 180개)"
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let lodgmentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "숙소이름입니다. 숙소이름입니다 숙소이름입니다 숙소이름입니다"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "₩82,930 / 박"
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
        attribute()
    }
    
    private func attribute() {
        contentView.addSubview(imageView)
        contentView.addSubview(reviewLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(lodgmentTitleLabel)
        contentView.addSubview(priceLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView)
            make.width.height.equalTo(130)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.width.equalTo(120)
            make.height.equalTo(25)
        }
        
        heartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(reviewLabel.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        lodgmentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(lodgmentTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.height.equalTo(25)
        }
    }
    
    private func layout() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    func bind(viewModel: MapCollectionCellViewModel) {
        heartButton.rx.tap
            .bind(to: viewModel.tappedHeart)
            .disposed(by: disposeBag)
        
        viewModel
            .updateName
            .bind(to: lodgmentTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .updateTotalPrice
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .updateReview
            .bind(to: reviewLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .updateWish
            .bind(onNext: updateHeartUI)
            .disposed(by: disposeBag)
        
        viewModel.viewLoad.accept(())
    }
    
    private func updateHeartUI(by wish: Bool) {
        wish ? heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) :  heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func setData(with lodging: Lodging) {
        reviewLabel.text = "별 \(lodging.rating) (후기 \(lodging.review)개)"
        lodgmentTitleLabel.text = lodging.name
        priceLabel.text = "₩\(lodging.price) / 박"
    }
}
