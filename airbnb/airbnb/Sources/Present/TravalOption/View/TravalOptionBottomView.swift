//
//  TravalOptionBottomView.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/02.
//

import UIKit

final class TravalOptionBottomView: UIView {
    
    let allRemoveButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString.create("전체 삭제", options: [.underLined]), for: .normal)
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("검색", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private var isShow = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        addSubview(allRemoveButton)
        addSubview(searchButton)
        
        snp.makeConstraints {
            $0.top.equalTo(searchButton).inset(-16)
        }
        
        allRemoveButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(searchButton)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }
}

extension TravalOptionBottomView: ViewAnimation {
    func shouldAnimation(isAnimate: Bool) -> Bool {
        isShow != isAnimate
    }
    
    func didShowAnimation(safeAreaGuide: UILayoutGuide) {
        alpha = 0
    }
    
    func startShowAnimation(safeAreaGuide: UILayoutGuide) {
        alpha = 1
        snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
    }
    
    func finishShowAnimation() {
        isShow = true
    }
    
    func startHiddenAnimation() {
        alpha = 1
        snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(100)
        }
    }
    func finishHiddenAnimation() {
        alpha = 0
        isShow = false
    }
}
