//
//  NewMapViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import MapKit
import RxRelay
import RxSwift

protocol MapViewModelAction {
    var viewDidLoad: PublishRelay<Void> { get }
    var selectedCell: PublishRelay<IndexPath> { get }
}

final class MapViewModel {
    let viewDidLoad = PublishRelay<Void>()
    let selectedAnnotation = PublishRelay<Lodging>()
    
    let updateRegion = PublishRelay<MKCoordinateRegion>()
    let updateLodging = PublishRelay<[MapCollectionCellViewModel]>()
    let updatePin = PublishRelay<[Lodging]>()
    let presentDetail = PublishRelay<Int>()
    
    @Inject(\.mapRepository) private var mapRepository: MapRepository
    
    private let disposeBag = DisposeBag()
    
    init() {
        viewDidLoad
            .map { _ -> MKCoordinateRegion in
                let center = CLLocationCoordinate2D(latitude: 37.4908205, longitude: 127.0334173)
                let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0.005)
                return MKCoordinateRegion(center: center, span: span)
            }
            .bind(to: updateRegion)
            .disposed(by: disposeBag)
        
        let requestLodging = viewDidLoad
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.mapRepository.requestLodging()
            }
            .compactMap { $0.value }
            .share()
    
        selectedAnnotation
            .map { $0.id }
            .bind(to: presentDetail)
            .disposed(by: disposeBag)
        
        requestLodging
            .bind(to: updatePin)
            .disposed(by: disposeBag)
    }
}
