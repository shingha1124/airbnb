//
//  PriceAnnotation.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/24.
//

import MapKit
import SnapKit

final class PriceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordenate: CLLocationCoordinate2D) {
        self.coordinate = coordenate
        super.init()
    }
}

final class PriceAnnotationView: MKAnnotationView {
    static let identifier = "PriceAnnotationView"
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowPath = nil
    }
    
    func setPrice(price: String) {
        priceLabel.text = price
    }
}
