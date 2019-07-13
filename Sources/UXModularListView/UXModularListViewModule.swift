//
//  UXModularListViewModule.swift
//  UXModularListView
//
//  Created by Christian Schnorr on 13.07.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import UIKit


public protocol UXModularListViewModule: UIView {
    associatedtype ViewModel

    init(viewModel: ViewModel)
    var viewModel: ViewModel { get set }

    static func estimatedHeight(for viewModel: ViewModel, availableWidth: CGFloat) -> CGFloat
}
