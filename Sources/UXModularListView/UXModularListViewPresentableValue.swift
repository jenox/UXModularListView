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


/// Encapsulates a model value and a compatible module type.
///
/// Must erase the concrete value and module such that we can store many them in
/// a homogeneous list.
public struct UXModularListViewPresentableValue {
    public init<Value, Module>(_ value: Value, using module: Module.Type) where Module: UXModularListViewModule, Module.ViewModel == Value {
        self.reuseIdentifier = "\(Module.self)"

        self._materializeWithReusableView = { reusableView in
            if let reusableView = reusableView as? Module {
                reusableView.viewModel = value

                return reusableView
            } else {
                return Module.init(viewModel: value)
            }
        }

        self._estimatedHeightForAvailableWidth = { availableWidth in
            return Module.estimatedHeight(for: value, availableWidth: availableWidth)
        }
    }

    internal let reuseIdentifier: String?
    private let _materializeWithReusableView: (UIView?) -> UIView
    private let _estimatedHeightForAvailableWidth: (CGFloat) -> CGFloat

    internal func materialize(reusableView: UIView?) -> UIView {
        return self._materializeWithReusableView(reusableView)
    }

    internal func estimatedHeight(forAvailableWidth availableWidth: CGFloat) -> CGFloat {
        return self._estimatedHeightForAvailableWidth(availableWidth)
    }
}
