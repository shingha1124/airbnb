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
//            .compactMap { _ in
//                URL(string: "https://s3-alpha-sig.figma.com/img/4ee4/e169/870b792e3a4ae88671095fad825a8ef0?Expires=1654473600&Signature=TQ8Um2PqB135YjD9Nk4L51PJC5kzSV5lsp5oY9n-Y9QHAKzzW4zIrKXIEOjG5IeJUOYG-r3zS2uaWhLlkgDaDT-b5abY~BYGmBetze1xhXIgAWhdiVaYLvosEvFIFfD4RheMMFbCllOX9TgSwJo7FNv8Xv36Y24aGqTSmoaQBYjNzvnY55TgsbGOdAkTNppXZH6Wl1FgT5VuEUerqbfoQ4nqgntyY~P4ZWP7NydW5ksOzv-Wo1aJRm3sxgg~qB7KHeqYfKBxPSGtD4jF4Idozxiyzd~ipWVXLxIXC5xDgR~qGQF~xj2hs7T9JqpX2SbEYCA5ybVLKeGyf41k7o60Qg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA")
//            }
            .map { arroundTraval.imageUrl }
            .bind(to: updateThumbnail)
            .disposed(by: disposeBag)
        
        tappedCell
            .map { arroundTraval }
            .bind(to: tappedCellWithDate)
            .disposed(by: disposeBag)
    }
}
