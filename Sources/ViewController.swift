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
        view.viewModels = [.int(23), .string("Lorem")]

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            view.viewModels = [.string("Lorem\nIpsum"), .double(.pi), .int(23)]
        })

        self.view = view
    }
}

enum ViewModel: Equatable {
    case int(Int)
    case double(Double)
    case string(String)
}

extension ViewModel: Identifiable {
    var id: String {
        switch self {
        case .int: return "int"
        case .double: return "double"
        case .string: return "string"
        }
    }
}

extension ViewModel {
    static var moduleProvider = UXModularListViewModuleProvider(ViewModel.presentableValue(for:))

    private static func presentableValue(for viewModel: ViewModel) -> UXModularListViewPresentableValue {
        switch viewModel {
        case .int(let value):
            return UXModularListViewPresentableValue(value, using: IntModule.self)
        case .double(let value):
            return UXModularListViewPresentableValue(value, using: DoubleModule.self)
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

    static func estimatedHeight(for viewModel: Int, availableWidth: CGFloat) -> CGFloat {
        return 44
    }
}

class DoubleModule: UILabel, UXModularListViewModule {
    var viewModel: Double {
        didSet { self.performFormattingUpdate() }
    }

    required init(viewModel: Double) {
        self.viewModel = viewModel

        super.init(frame: .null)

        self.performFormattingUpdate()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func performFormattingUpdate() {
        self.text = "Double \(self.viewModel)"
    }

    static func estimatedHeight(for viewModel: Double, availableWidth: CGFloat) -> CGFloat {
        return 44
    }
}

class StringModule: UILabel, UXModularListViewModule {
    var viewModel: String {
        didSet { self.performFormattingUpdate() }
    }

    required init(viewModel: String) {
        self.viewModel = viewModel

        super.init(frame: .null)

        self.numberOfLines = 0
        self.performFormattingUpdate()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func performFormattingUpdate() {
        self.text = "String \(self.viewModel)"
    }

    static func estimatedHeight(for viewModel: String, availableWidth: CGFloat) -> CGFloat {
        return 44
    }
}
