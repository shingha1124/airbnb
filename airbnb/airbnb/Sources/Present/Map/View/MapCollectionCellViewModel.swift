//
//  MapCollectionViewModel.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/30.
//

import UIKit
import RxRelay
import RxSwift

final class MapCollectionCellViewModel {
    let viewLoad = PublishRelay<Void>()
    let tappedHeart = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    let updateReview = PublishRelay<String>()
    let updateWish = PublishRelay<Bool>()
    let updateName = PublishRelay<String>()
    let updateTotalPrice = PublishRelay<String>()
    let updateHeartIcon = PublishRelay<Bool>()
    let tappedCellWithHeart = PublishRelay<Lodging>()
    
    let lodging: Lodging
    
    init(lodging: Lodging) {
        self.lodging = lodging

        tappedHeart
            .map { lodging }
            .bind(to: tappedCellWithHeart)
            .disposed(by: disposeBag)
        
        viewLoad
            .map { "별 \(lodging.rating) (후기 \(lodging.review)개)" }
            .bind(to: updateReview)
            .disposed(by: disposeBag)
        
        viewLoad
            .map { lodging.wish }
            .bind(to: updateWish)
            .disposed(by: disposeBag)
        
        viewLoad
            .map { lodging.name }
            .bind(to: updateName)
            .disposed(by: disposeBag)
        
        viewLoad
            .map { "₩\(lodging.totalPrice) / 박" }
            .bind(to: updateTotalPrice)
            .disposed(by: disposeBag)
    }
}
