//
//  MapView.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/23.
//

import MapKit
import SnapKit

final class MapView: UIView {
    
    lazy var mkMapView: MKMapView = {
        let mkMapView = MKMapView()
        mkMapView.mapType = .standard
        let zoomLevel = 15.0
        let centerPoint = CLLocationCoordinate2D(latitude: 37.4908205, longitude: 127.0334173)
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, zoomLevel) * Double(self.frame.width) / 256)
        mkMapView.setRegion(MKCoordinateRegion(center: centerPoint, span: span), animated: true)
        mkMapView.register(PriceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PriceAnnotationView.identifier)
        return mkMapView
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: frame.width - 60, height: 130)
        layout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MapCollectionCell.self, forCellWithReuseIdentifier: MapCollectionCell.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(mkMapView)
        addSubview(menuButton)
        addSubview(collectionView)
        
        mkMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(150)
            make.width.equalToSuperview()
        }
    }
}
