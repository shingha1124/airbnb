//
//  NewMapViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import Foundation
import MapKit
import RxRelay
import RxSwift

protocol MapViewModelAction {
    var viewDidLoad: PublishRelay<Void> { get }
    var selectedCell: PublishRelay<IndexPath> { get }
}

final class MapViewModel {
    let viewDidLoad = PublishRelay<Void>()
    let selectedCell = PublishRelay<IndexPath>()
    let selectedAnnotation = PublishRelay<Lodging>()
    
    let updateRegion = PublishRelay<MKCoordinateRegion>()
    let updateLodging = PublishRelay<[MapCollectionCellViewModel]>()
    let updatePin = PublishRelay<[Lodging]>()
    let presentDetail = PublishRelay<Int>()
    
    @Inject(\.mapRepository) private var mapRepository: MapRepository
    
    private let disposeBag = DisposeBag()
    
    private var lodgings: [Int: MapCollectionCellViewModel] = [:]
    
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
        
        selectedCell
            .withLatestFrom(requestLodging) { indexPath, lodgings in
                lodgings[indexPath.item].id
            }
            .bind(to: presentDetail)
            .disposed(by: disposeBag)
        
        selectedAnnotation
            .map { $0.id }
            .bind(to: presentDetail)
            .disposed(by: disposeBag)
        
        requestLodging
            .bind(to: updatePin)
            .disposed(by: disposeBag)
        
        requestLodging
            .map { $0.map { MapCollectionCellViewModel(lodging: $0) } }
            .do(onNext: { [weak self] models in
                for model in models {
                    self?.lodgings[model.lodging.id] = model
                }
            })
            .bind(to: updateLodging)
            .disposed(by: disposeBag)
        
        let tappedCells = updateLodging
            .flatMapLatest { viewModels -> Observable<Lodging> in
                let tappedCells = viewModels.map {
                    $0.tappedCellWithHeart.asObservable()
                }
                return .merge(tappedCells)
            }
            .share()
        
        let requestHeart = tappedCells
            .withUnretained(self)
            .flatMapLatest { model, lodging in
                model.mapRepository.requestUpdateWish(lodging: lodging)
            }
            .share()
        
        requestHeart
            .compactMap { $0.value }
            .withUnretained(self)
            .compactMap { model, lodging in
                model.lodgings[lodging.id]
            }
            .bind(onNext: { cellModel in
                cellModel.updateWish.accept(!cellModel.lodging.wish)
            })
            .disposed(by: disposeBag)
    }
}
