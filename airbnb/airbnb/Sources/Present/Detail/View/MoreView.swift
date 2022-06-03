//
//  MoreView.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/31.
//

import SnapKit

final class MoreView: UIView {
    
    private lazy var moreView = UIView(frame: self.frame)
    
    private let shapeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let moreSeeLabel: UILabel = {
        let label = UILabel()
        label.text = "더보기"
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(moreView)
        moreView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        moreView.addSubview(moreSeeLabel)
        moreSeeLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        moreView.addSubview(shapeButton)
        
        shapeButton.snp.makeConstraints { make in
            make.leading.equalTo(moreSeeLabel.snp.trailing)
            make.centerY.equalTo(moreSeeLabel)
            make.height.width.equalTo(40)
        }
    }
}
