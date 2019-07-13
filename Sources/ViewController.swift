//
//  ViewController.swift
//  UXModularListView
//
//  Created by Christian Schnorr on 13.07.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    override func loadView() {
        let view = UXModularListView<ViewModel>(moduleProvider: ViewModel.moduleProvider)
        view.viewModels = [.int(23), .string("42")]

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            view.viewModels.append(.int(4))
        })

        self.view = view
    }
}

enum ViewModel {
    case int(Int)
    case string(String)
}

extension ViewModel {
    static var moduleProvider = UXModularListViewModuleProvider(ViewModel.presentableValue(for:))

    private static func presentableValue(for viewModel: ViewModel) -> UXModularListViewPresentableValue {
        switch viewModel {
        case .int(let value):
            return UXModularListViewPresentableValue(value, using: IntModule.self)
        case .string(let value):
            return UXModularListViewPresentableValue(value, using: StringModule.self)
        }
    }
}

class IntModule: UILabel, UXModularListViewModule {
    var viewModel: Int {
        didSet { self.performFormattingUpdate() }
    }

    required init(viewModel: Int) {
        self.viewModel = viewModel

        super.init(frame: .null)

        self.performFormattingUpdate()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func performFormattingUpdate() {
        self.text = "Int \(self.viewModel)"
    }
}

class StringModule: UILabel, UXModularListViewModule {
    var viewModel: String {
        didSet { self.performFormattingUpdate() }
    }

    required init(viewModel: String) {
        self.viewModel = viewModel

        super.init(frame: .null)

        self.performFormattingUpdate()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func performFormattingUpdate() {
        self.text = "String \(self.viewModel)"
    }
}
