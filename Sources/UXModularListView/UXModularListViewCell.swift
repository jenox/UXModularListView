/*
 MIT License

 Copyright (c) 2019 Christian Schnorr

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

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
