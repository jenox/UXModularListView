//
//  UXModularListViewPresentableValue.swift
//  UXModularListView
//
//  Created by Christian Schnorr on 13.07.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import UIKit


/// Encapsulates a model value and a compatible module type.
public struct UXModularListViewPresentableValue {
    public init<Value, Module>(_ value: Value, using module: Module.Type) where Module: UXModularListViewModule, Module.ViewModel == Value {
        self.reuseIdentifier = "\(Module.self)"

        self._materializeWithReusableView = { reusableView in
            if let reusableView = reusableView as? Module {
                reusableView.viewModel = value

                return reusableView
            } else {
                return Module.init(viewModel: value)
            }
        }

        self._estimatedHeightForAvailableWidth = { availableWidth in
            return Module.estimatedHeight(for: value, availableWidth: availableWidth)
        }
    }

    internal let reuseIdentifier: String?
    private let _materializeWithReusableView: (UIView?) -> UIView
    private let _estimatedHeightForAvailableWidth: (CGFloat) -> CGFloat

    internal func materialize(reusableView: UIView?) -> UIView {
        return self._materializeWithReusableView(reusableView)
    }

    internal func estimatedHeight(forAvailableWidth availableWidth: CGFloat) -> CGFloat {
        return self._estimatedHeightForAvailableWidth(availableWidth)
    }
}
