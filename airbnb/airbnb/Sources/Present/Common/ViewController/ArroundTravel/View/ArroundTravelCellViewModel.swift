//
//  AroundTravelCellViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay
import RxSwift

final class ArroundTravelCellViewModel: ViewModel {
    
    struct Action {
        let viewLoad = PublishRelay<Void>()
        let tappedCell = PublishRelay<Void>()
        let tappedCellWithDate = PublishRelay<ArroundTraval>()
    }
    
    struct State {
        let updateName = PublishRelay<String>()
        let updatedistance = PublishRelay<String>()
        let updateThumbnail = PublishRelay<URL>()
    }
    
    let action = Action()
    let state = State()
    let disposeBag = DisposeBag()
    
    init(arroundTraval: ArroundTraval) {
        
        action.viewLoad
            .map { arroundTraval.name }
            .bind(to: state.updateName)
            .disposed(by: disposeBag)
        
        action.viewLoad
            .map { arroundTraval.distance }
            .bind(to: state.updatedistance)
            .disposed(by: disposeBag)
        
        action.viewLoad
            .map { arroundTraval.imageUrl }
            .bind(to: state.updateThumbnail)
            .disposed(by: disposeBag)
        
        action.tappedCell
            .map { arroundTraval }
            .bind(to: action.tappedCellWithDate)
            .disposed(by: disposeBag)
    }
}
