//
//  LodgingCollectionViewModel.swift
//  airbnb
//
//  Created by 김동준 on 2022/06/07.
//

import MapKit
import RxRelay
import RxSwift

//protocol MapViewModelAction {
//    var viewDidLoad: PublishRelay<Void> { get }
//    var selectedCell: PublishRelay<IndexPath> { get }
//}

final class LodgingCollectionViewModel: ViewModel {
    let action = Action()
    let state = State()
    struct Action {
        let viewDidLoad = PublishRelay<Void>()
        let selectedCell = PublishRelay<IndexPath>()
    }
    
    struct State {
        let updateLodging = PublishRelay<[MapCollectionCellViewModel]>()
        let presentDetail = PublishRelay<Int>()
    }
    
    @Inject(\.mapRepository) private var mapRepository: MapRepository
    
    private let disposeBag = DisposeBag()
    
    private var lodgings: [Int: MapCollectionCellViewModel] = [:]
    
    init() {
        let requestLodging = action.viewDidLoad
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.mapRepository.requestLodging()
            }
            .compactMap { $0.value }
            .share()
        
        action.selectedCell
            .withLatestFrom(requestLodging) { indexPath, lodgings in
                lodgings[indexPath.item].id
            }
            .bind(to: state.presentDetail)
            .disposed(by: disposeBag)
        
        requestLodging
            .map { $0.map { MapCollectionCellViewModel(lodging: $0) } }
            .do(onNext: { [weak self] models in
                for model in models {
                    self?.lodgings[model.lodging.id] = model
                }
            })
                .bind(to: state.updateLodging)
            .disposed(by: disposeBag)
        
                let tappedCells = state.updateLodging
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
