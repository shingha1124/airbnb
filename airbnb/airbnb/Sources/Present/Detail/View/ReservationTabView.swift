//
//  ReservationTabView.swift
//  airbnb
//
//  Created by 김동준 on 2022/06/02.
//

import SnapKit

final class ReservationTabView: UIView {
    
    private lazy var reservationView = UIView(frame: self.frame)
    
    private let reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("예약하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "원72000 /박"
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "6월 1일 - 6월 3일"
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        attribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(reservationView)
        reservationView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        alreadySetDate()
    }
    
    private func attribute() {
        reservationView.backgroundColor = .systemGray6
    }
    
    private func alreadySetDate() {
        reservationView.addSubview(priceLabel)
        reservationView.addSubview(dateLabel)
        reservationView.addSubview(reservationButton)
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(reservationView.snp.centerX).offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(reservationView.snp.centerX).offset(-15)
        }
        
        reservationButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalTo(reservationView.snp.centerX).offset(15)
            make.bottom.equalTo(dateLabel.snp.bottom)
        }
    }
}
