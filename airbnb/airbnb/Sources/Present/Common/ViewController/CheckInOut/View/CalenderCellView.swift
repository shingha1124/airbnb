//
//  NewCalenderCellView.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/26.
//

import RxSwift
import UIKit

final class CalenderCellView: BaseCollectionViewCell, View {
    
    private let startDateView: GradientView = {
        let view = GradientView()
        view.isHidden = true
        let colors: [UIColor] = [
            .grey6.withAlphaComponent(0),
            .grey6.withAlphaComponent(1)
        ]
        
        view.set(
            colors: colors,
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 0.8, y: 0.5)
        )
        return view
    }()
    
    private let endDateView: GradientView = {
        let view = GradientView()
        view.isHidden = true
        let colors: [UIColor] = [
            .grey6.withAlphaComponent(0),
            .grey6.withAlphaComponent(1)
        ]
        
        view.set(
            colors: colors,
            startPoint: CGPoint(x: 0.8, y: 0.5),
            endPoint: CGPoint(x: 0, y: 0.5)
        )
        return view
    }()
    
    private lazy var selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey1
        view.isHidden = true
        view.layer.cornerRadius = self.frame.width / 2
        return view
    }()
    
    private lazy var inRangeView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey6
        view.isHidden = true
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .grey1
        label.textAlignment = .center
        return label
    }()

    private let cellButton = UIButton()
    
    func bind(to viewModel: CalenderCellViewModel) {
        
        if let date = viewModel.state.date {
            dayLabel.text = date.string("d")
            updateState(Date() > date ? .notSelect: .none)
        } else {
            dayLabel.text = ""
            updateState(.none)
        }
        
        cellButton.rx.tap
            .bind(to: viewModel.action.tappedCell)
            .disposed(by: disposeBag)
        
        viewModel.state.updateState
            .bind(onNext: updateState)
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        contentView.addSubview(startDateView)
        contentView.addSubview(endDateView)
        contentView.addSubview(inRangeView)
        contentView.addSubview(selectedView)
        contentView.addSubview(dayLabel)
        contentView.addSubview(cellButton)
        
        startDateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        endDateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        inRangeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dayLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cellButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateState(_ state: CalenderCellState) {
        switch state {
        case .start, .end:
            dayLabel.textColor = .white
            selectedView.isHidden = false
            inRangeView.isHidden = true
        case .inRange:
            dayLabel.textColor = .grey1
            selectedView.isHidden = true
            inRangeView.isHidden = false
        case .none:
            dayLabel.textColor = .grey1
            selectedView.isHidden = true
            inRangeView.isHidden = true
        case .notSelect:
            dayLabel.textColor = .grey4
        }
        
        startDateView.isHidden = state != .start
        endDateView.isHidden = state != .end
    }
}
