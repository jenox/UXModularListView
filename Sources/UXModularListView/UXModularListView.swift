//
//  UXModularListView.swift
//  UXModularListView
//
//  Created by Christian Schnorr on 13.07.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import UIKit


public class UXModularListView<T>: UIView, UITableViewDataSource, UITableViewDelegate where T: Identifiable {

    // MARK: - Initialization

    public init(moduleProvider: UXModularListViewModuleProvider<T>) {
        self.moduleProvider = moduleProvider

        super.init(frame: .null)

        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.establishSubviewHierarchy()
        self.configureLayoutConstraints()
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }


    // MARK: - Configuration

    private let moduleProvider: UXModularListViewModuleProvider<T>

    public var viewModels: [T] = [] {
        didSet {
            // Triggering animations when the data source hasn't been queried
            // yet causes it to query the data source before the animation but
            // when the new model values are already set, resulting in invalid
            // updates. This ensures updates are only applied with an animation
            // when it is safe to do so.
            if self.tableView.numberOfRows(inSection: 0) == oldValue.count {
                self.tableView.animate(from: oldValue, to: self.viewModels)

                // The content of items which retained their identity may still
                // have changed. The call to performBatchUpdates ensures the
                // cells get a change to resize to fit their new content.
                self.tableView.performBatchUpdates({
                    for cell in self.tableView.visibleCells as! [UXModularListViewCell] {
                        if let indexPath = self.tableView.indexPath(for: cell) {
                            self.configure(cell, forRowAt: indexPath)
                        }
                    }
                })
            } else {
                self.tableView.reloadData()
            }
        }
    }


    // MARK: - Subview Management

    private let tableView = UXModularListView.makeTableView()

    private func establishSubviewHierarchy() {
        self.addSubview(self.tableView)
    }

    private func configureLayoutConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.tableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.tableView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.tableView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.tableView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }


    // MARK: - Table View Management

    private func presentableValue(at indexPath: IndexPath) -> UXModularListViewPresentableValue {
        let viewModel = self.viewModels[indexPath.row]
        let presentableValue = self.moduleProvider.presentableValue(for: viewModel)

        return presentableValue
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UXModularListViewCell

        if let reuseIdentifier = self.presentableValue(at: indexPath).reuseIdentifier {
            tableView.register(UXModularListViewCell.self, forCellReuseIdentifier: reuseIdentifier)

            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UXModularListViewCell
        } else {
            cell = UXModularListViewCell(style: .default, reuseIdentifier: nil)
        }

        self.configure(cell, forRowAt: indexPath)

        return cell
    }

    private func configure(_ cell: UXModularListViewCell, forRowAt indexPath: IndexPath) {
        let presentableValue = self.presentableValue(at: indexPath)

        cell.presentedView = presentableValue.materialize(reusableView: cell.presentedView)
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let presentableValue = self.presentableValue(at: indexPath)
        let availableWidth = tableView.bounds.width

        return presentableValue.estimatedHeight(forAvailableWidth: availableWidth)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


    // MARK: - Styling

    private static func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = true
        tableView.alwaysBounceHorizontal = false
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none

        return tableView
    }
}
