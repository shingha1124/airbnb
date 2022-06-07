//
//  LodgingListViewCellModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation
import RxRelay
import RxSwift

final class LodgingListViewCellModel: ViewModel {
    
    struct Action {
        let loadCellData = PublishRelay<Void>()
    }
    
    struct State {
        let updatedThumbnail = PublishRelay<URL>()
        let updatedRating = PublishRelay<Double>()
        let updatedReview = PublishRelay<Int>()
        let updatedName = PublishRelay<String>()
        let updatedPrice = PublishRelay<Int>()
        let updatedTotalPrice = PublishRelay<Int>()
        let updatedWish = PublishRelay<Bool>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    
    init(lodging: Lodging) {
        action.loadCellData
            .map { _ in lodging.imageUrl }
            .bind(to: state.updatedThumbnail)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { _ in lodging.rating }
            .bind(to: state.updatedRating)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { _ in lodging.review }
            .bind(to: state.updatedReview)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { _ in lodging.name }
            .bind(to: state.updatedName)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { _ in lodging.price }
            .bind(to: state.updatedPrice)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .compactMap { _ in lodging.totalPrice }
            .bind(to: state.updatedTotalPrice)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { _ in lodging.wish }
            .bind(to: state.updatedWish)
            .disposed(by: disposeBag)
    }
}
