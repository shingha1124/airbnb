//
//  NewMapViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import MapKit
import RxRelay
import RxSwift

final class MapViewModel: ViewModel {
    let action = Action()
    let state = State()
    
    struct Action {
        let viewDidLoad = PublishRelay<Void>()
        let selectedAnnotation = PublishRelay<Lodging>()
        let permissionCheckResult = PublishRelay<Bool>()
        let userLocation = PublishRelay<CLLocation>()
    }
    
    struct State {
        let updateRegion = PublishRelay<MKCoordinateRegion>()
        let updateLodging = PublishRelay<[MapCollectionCellViewModel]>()
        let permissionStateUpdate = PublishRelay<Bool>()
        let updatePin = PublishRelay<[Lodging]>()
        let presentDetail = PublishRelay<Int>()
        let presentSetting = PublishRelay<Void>()
    }

    @Inject(\.mapRepository) private var mapRepository: MapRepository
    
    private let disposeBag = DisposeBag()
    
    init() {
        action.viewDidLoad
            .map { _ -> MKCoordinateRegion in
                let center = CLLocationCoordinate2D(latitude: 37.4908205, longitude: 127.0334173)
                let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0.005)
                return MKCoordinateRegion(center: center, span: span)
            }
            .bind(to: state.updateRegion)
            .disposed(by: disposeBag)
        
        action.permissionCheckResult
            .distinctUntilChanged()
            .bind(to: state.permissionStateUpdate)
        .disposed(by: disposeBag)
        
        let requestLodging = action.viewDidLoad
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.mapRepository.requestLodging()
            }
            .compactMap { $0.value }
            .share()
    
        action.selectedAnnotation
            .map { $0.id }
            .bind(to: state.presentDetail)
            .disposed(by: disposeBag)
        
        requestLodging
            .bind(to: state.updatePin)
            .disposed(by: disposeBag)
    }
}
