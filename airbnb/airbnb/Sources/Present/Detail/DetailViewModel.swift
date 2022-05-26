//
//  DetailViewModel.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/26.
//

import RxRelay
import RxSwift

final class DetailViewModel {
    
    var lodgingID = PublishRelay<Int>()
    var backButtonTapped = PublishRelay<Void>()
    
    @Inject(\.mapRepository) private var mapRepository: MapRepository
    var presentMapView = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        backButtonTapped
            .bind(to: presentMapView)
            .disposed(by: disposeBag)
    }
}
