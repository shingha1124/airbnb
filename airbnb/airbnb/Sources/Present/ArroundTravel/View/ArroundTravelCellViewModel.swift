//
//  AroundTravelCellViewModel.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/24.
//

import Foundation
import RxRelay
import RxSwift

final class ArroundTravelCellViewModel: ArroundTravelCellViewModelBinding, ArroundTravelCellViewModelAction, ArroundTravelCellViewModelState {
    
    func action() -> ArroundTravelCellViewModelAction { self }
    
    let viewLoad = PublishRelay<Void>()
    let tappedCell = PublishRelay<Void>()
    let tappedCellWithDate = PublishRelay<ArroundTraval>()
    
    func state() -> ArroundTravelCellViewModelState { self }
    
    let updateName = PublishRelay<String>()
    let updatedistance = PublishRelay<String>()
    let updateThumbnail = PublishRelay<URL>()
    
    private var disposeBag = DisposeBag()
    
    init(arroundTraval: ArroundTraval) {
        
        viewLoad
            .map { arroundTraval.name }
            .bind(to: updateName)
            .disposed(by: disposeBag)
        
        viewLoad
            .map { arroundTraval.distance }
            .bind(to: updatedistance)
            .disposed(by: disposeBag)
        
        viewLoad
            .map { arroundTraval.imageUrl }
            .bind(to: updateThumbnail)
            .disposed(by: disposeBag)
        
        tappedCell
            .map { arroundTraval }
            .bind(to: tappedCellWithDate)
            .disposed(by: disposeBag)
    }
}
