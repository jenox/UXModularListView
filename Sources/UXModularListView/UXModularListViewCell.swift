//
//  UXModularListViewCell.swift
//  UXModularListView
//
//  Created by Christian Schnorr on 13.07.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import UIKit


internal final class UXModularListViewCell: UITableViewCell {

    // MARK: - Initialization

    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
    }

    internal required init(coder: NSCoder) {
        fatalError()
    }


    // MARK: - Presented View

    internal var presentedView: UIView? = nil {
        willSet {
            precondition(newValue !== self)
            precondition(newValue !== self.contentView)

            if let oldValue = self.presentedView, oldValue !== newValue {
                if oldValue.superview === self.contentView {
                    oldValue.removeFromSuperview()
                }
            }
        }
        didSet {
            if let newValue = self.presentedView, newValue !== oldValue {
                self.contentView.addSubview(newValue)

                newValue.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    newValue.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                    newValue.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                    newValue.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                    newValue.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
                ])
            }
        }
    }
}
