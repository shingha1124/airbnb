//
//  DetailViewModel.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/26.
//

import RxRelay
import RxSwift

final class DetailViewModel {
    let backButtonTapped = PublishRelay<Void>()
    
    @Inject(\.mapRepository) private var mapRepository: MapRepository
    let presentMapView = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    init(id: Int) {
        backButtonTapped
            .bind(to: presentMapView)
            .disposed(by: disposeBag)
    }
}
