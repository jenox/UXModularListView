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
        let view = UXModularListView<ViewModel>()
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
