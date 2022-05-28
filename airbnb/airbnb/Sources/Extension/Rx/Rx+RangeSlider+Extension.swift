//
//  Rx+RangeSlider+Extension.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/28.
//

import RxSwift
import RxCocoa
import WARangeSlider

extension Reactive where Base: RangeSlider {
    public var tap: ControlEvent<Void> {
        controlEvent(.valueChanged)
    }
    
    public var changeValue: ControlProperty<(Double, Double)> {
        base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { base in
                (base.lowerValue, base.upperValue)
            },
            setter: { base, catchValue in
                base.lowerValue = catchValue.0
                base.upperValue = catchValue.1
            })
    }
}
