//
//  DetailViewController.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/25.
//

import RxSwift
import UIKit

final class DetailViewController: UIViewController {
    
    private let imageSlider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 25
        return button
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.red.cgColor
        button.layer.cornerRadius = 25
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.yellow.cgColor
        button.layer.cornerRadius = 25
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "asdfasdfdsa dafsdsafdsa fsaeklmek cfeiowjmrfeoiw crewo"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "별 4.80(후기 127개)"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "서초구, 서울, 한국"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let grayLine: UIView = {
        let line = UIView()
        line.layer.backgroundColor = UIColor.systemGray4.cgColor
        return line
    }()
    
    private let regidenceLabel: UILabel = {
        let label = UILabel()
        label.text = "레지던스 전체"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var hostLabel: UILabel = {
        let label = UILabel()
        label.text = "호스트: Jong님"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let hostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.backgroundColor = UIColor.black.cgColor
        return imageView
    }()
    
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: DetailViewModel) {
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
        
    private func bind() {
        backButton.rx.tap
            .bind(to: viewModel.backButtonTapped)
            .disposed(by: disposeBag)
    
        viewModel.presentMapView
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.presentMapViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(imageSlider)
        view.addSubview(backButton)
        view.addSubview(heartButton)
        view.addSubview(shareButton)
        view.addSubview(titleLabel)
        view.addSubview(reviewLabel)
        view.addSubview(addressLabel)
        view.addSubview(grayLine)
        view.addSubview(regidenceLabel)
        view.addSubview(hostLabel)
        view.addSubview(hostImageView)
        
        imageSlider.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
        
        heartButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.width.height.equalTo(50)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(heartButton.snp.centerY)
            make.width.height.equalTo(50)
            make.trailing.equalTo(heartButton.snp.leading).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageSlider.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(50)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(30)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(15)
        }
        
        grayLine.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(1)
        }
        
        regidenceLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(25)
        }
        
        hostLabel.snp.makeConstraints { make in
            make.top.equalTo(regidenceLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(25)
        }
        
        hostImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(grayLine.snp.bottom).offset(25)
            make.width.height.equalTo(50)
        }
    }
    
    private func presentMapViewController() {
        dismiss(animated: true, completion: nil)
    }
}
