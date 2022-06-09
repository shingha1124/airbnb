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

final class MapLodgingViewController: UIViewController {

    private let viewModel: MapLodgingViewModel
    private let disposeBag = DisposeBag()
    private let didSelectAnnotation = PublishRelay<Lodging>()
    
//    private let mapViewController = MapViewController(viewModel: MapViewModel())
//    private let collectionViewController = LoadgingCollectionViewController(viewModel: LodgingCollectionViewModel())
//
    init(viewModel: MapLodgingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        attribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.childViewControllers
            .withUnretained(self)
            .bind { vc, childViewControllers in
                vc.layout(childViewControllers: childViewControllers) }
            .disposed(by: disposeBag)
        
        viewModel.presentDetailView
            .withUnretained(self)
            .bind { vc, id in
                let detailViewController = DetailViewController(viewModel: DetailViewModel(id: id))
                detailViewController.modalPresentationStyle = .fullScreen
                vc.present(detailViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
    }
    
    private func layout(childViewControllers: [String: UIViewController]) {
        guard let mapViewController = childViewControllers[MapViewController.id] else { return }
        guard let collectionViewController = childViewControllers[LodgingCollectionViewController.id] else { return }
        
        view.addSubview(mapViewController.view)
        view.addSubview(collectionViewController.view)
        
        collectionViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
    }
}
