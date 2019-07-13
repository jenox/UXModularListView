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
        self._presentInContentView = { contentView in
            if let contentView = contentView as? Module {
                contentView.viewModel = value

                return contentView
            } else {
                return Module.init(viewModel: value)
            }
        }
    }

    internal let reuseIdentifier: String?
    private let _presentInContentView: (UIView?) -> UIView

    internal func materialize(reusableView: UIView?) -> UIView {
        return _presentInContentView(reusableView)
    }
}
