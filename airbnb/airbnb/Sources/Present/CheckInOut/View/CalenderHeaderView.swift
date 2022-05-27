//
//  CalenderHeaderCellView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/26.
//

import UIKit

final class CalenderHeaderView: UICollectionReusableView {
    static var identifier: String { .init(describing: self) }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
