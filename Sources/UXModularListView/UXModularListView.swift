//
//  UXModularListView.swift
//  UXModularListView
//
//  Created by Christian Schnorr on 13.07.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import UIKit


public class UXModularListView<T>: UIView, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Initialization

    public init() {
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

    public var viewModels: [T] = [] {
        didSet { self.tableView.reloadData() }
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

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel!.text = "Row \(indexPath.row + 1)"

        return cell
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

        return tableView
    }
}
