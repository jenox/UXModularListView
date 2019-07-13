//
//  UXModularListViewModuleProvider.swift
//  UXModularListView
//
//  Created by Christian Schnorr on 13.07.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import Swift


/// Maps model values to (potentially derived) values and compatible module types.
public struct UXModularListViewModuleProvider<ViewModel> {
    public init(_ closure: @escaping (ViewModel) -> UXModularListViewPresentableValue) {
        self._presentableValueForViewModel = closure
    }

    private let _presentableValueForViewModel: (ViewModel) -> UXModularListViewPresentableValue

    internal func presentableValue(for viewModel: ViewModel) -> UXModularListViewPresentableValue {
        return self._presentableValueForViewModel(viewModel)
    }
}
