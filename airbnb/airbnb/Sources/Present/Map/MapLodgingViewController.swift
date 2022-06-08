//
//  MapLodgingViewController.swift
//  airbnb
//
//  Created by 김동준 on 2022/06/07.
//

import MapKit
import RxRelay
import RxSwift
import UIKit

final class MapLodgingViewController: BaseViewController, View {
    
    var disposeBag = DisposeBag()
    private let didSelectAnnotation = PublishRelay<Lodging>()
    
    private lazy var mapViewController: MapViewController = {
        let viewController = MapViewController()
        viewController.viewModel = viewModel?.mapViewModel
        return viewController
    }()
    
    private lazy var collectionViewController: LodgingCollectionViewController = {
        let viewController = LodgingCollectionViewController()
        viewController.viewModel = viewModel?.collectionViewModel
        return viewController
    }()
    
    func bind(to viewModel: MapLodgingViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.state.childViewControllers
            .withUnretained(self)
            .bind { vc, _ in
                vc.layout()
            }
            .disposed(by: disposeBag)
        
        viewModel.action.presentDetailView
            .withUnretained(self)
            .bind { vc, id in
                let detailViewController = DetailViewController(viewModel: DetailViewModel(id: id))
                detailViewController.modalPresentationStyle = .fullScreen
                vc.present(detailViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(mapViewController.view)
        view.addSubview(collectionViewController.view)
        
        collectionViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
    }
}
