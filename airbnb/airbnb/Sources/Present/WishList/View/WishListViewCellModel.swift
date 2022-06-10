//
//  LodgingListViewCellModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/06/07.
//

import Foundation
import RxRelay
import RxSwift

final class WishListViewCellModel: ViewModel {
    
    struct Action {
        let loadCellData = PublishRelay<Void>()
        let tappedWishButton = PublishRelay<Void>()
        let tappedWishButtonWithValue = PublishRelay<(Bool, Wish)>()
        let tappedCell = PublishRelay<Void>()
        let tappedCellWithValue = PublishRelay<Wish>()
        let switchWish = PublishRelay<Void>()
    }
    
    struct State {
        let updatedThumbnail = PublishRelay<URL>()
        let updatedRating = PublishRelay<Double>()
        let updatedReview = PublishRelay<Int>()
        let updatedName = PublishRelay<String>()
        let updatedPrice = PublishRelay<Int>()
        let updatedWish = PublishRelay<Bool>()
    }
    
    let action = Action()
    let state = State()
    private let disposeBag = DisposeBag()
    
    init(wish: Wish) {
        action.loadCellData
            .compactMap { _ in wish.imageUrl }
            .bind(to: state.updatedThumbnail)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { _ in wish.rating }
            .bind(to: state.updatedRating)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { _ in wish.review }
            .bind(to: state.updatedReview)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { _ in wish.name }
            .bind(to: state.updatedName)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { _ in wish.price }
            .bind(to: state.updatedPrice)
            .disposed(by: disposeBag)
        
        action.loadCellData
            .map { true }
            .bind(to: state.updatedWish)
            .disposed(by: disposeBag)
        
        action.tappedWishButton
            .withLatestFrom(state.updatedWish)
            .map { ($0, wish) }
            .bind(to: action.tappedWishButtonWithValue)
            .disposed(by: disposeBag)
        
        action.tappedCell
            .map { wish }
            .bind(to: action.tappedCellWithValue)
            .disposed(by: disposeBag)
        
        action.switchWish
            .withLatestFrom(state.updatedWish)
            .map { !$0 }
            .bind(to: state.updatedWish)
            .disposed(by: disposeBag)
    }
}
