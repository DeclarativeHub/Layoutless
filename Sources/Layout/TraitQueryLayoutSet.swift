//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Srdan Rasic (@srdanrasic)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

public class TraitQueryLayoutSet: LayoutNode {

    public let layouts: [TraitQuery: AnyLayout]

    private weak var container: UIView?
    private var revertable: AnyRevertable?
    private var parentRevertable: Revertable
    private var previousLayoutKey: TraitQuery?

    public init(_ layouts: [TraitQuery: AnyLayout], revertable: Revertable) {
        self.layouts = layouts
        self.parentRevertable = revertable
    }

    public func layout(in container: UIView) -> Revertable {
        self.container = container
        container.___associatedObjects.append(self)
        updateLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeTraitCollection), name: .windowTraitCollectionDidChange, object: nil)
        let revertable = Revertable()
        revertable.appendBlock {
            self.container = nil
            self.revertable?.revert()
            NotificationCenter.default.removeObserver(self)
        }
        parentRevertable.append(revertable)
        return revertable
    }

    @objc func didChangeTraitCollection() {
        updateLayout()
    }

    private func updateLayout() {
        guard let container = container else { return }
        let window = (container.window ?? UIApplication.shared.keyWindow) as? Window
        let windowTraitCollection = window?.windowTraitCollection ?? WindowTraitCollection(traitCollection: UIScreen.main.traitCollection, size: UIScreen.main.bounds.size)
        if let layout = layouts.first(where: { windowTraitCollection.matches($0.key) }) {
            guard previousLayoutKey != layout.key else { return }
            previousLayoutKey = layout.key
            revertable?.revert()
            revertable = layout.value.layout(in: container)
        }
    }
}

/// Define a set of layouts based on trait queries.
public func layoutSet(_ layouts: [TraitQuery: AnyLayout]) -> Layout<TraitQueryLayoutSet> {
    return Layout { revertable in
        return TraitQueryLayoutSet(layouts, revertable: revertable)
    }
}

public func layoutSet(_ layouts: (TraitQuery, AnyLayout)...) -> Layout<TraitQueryLayoutSet> {
    return Layout { revertable in
        return TraitQueryLayoutSet(Dictionary(layouts, uniquingKeysWith: { a, _ in a }), revertable: revertable)
    }
}

public func traitQuery(width: Length, layout: () -> AnyLayout) -> (TraitQuery, AnyLayout) {
    return (TraitQuery(width: width), layout())
}

public func traitQuery(height: Length, layout: () -> AnyLayout) -> (TraitQuery, AnyLayout) {
    return (TraitQuery(height: height), layout())
}

public func traitQuery(width: Length, height: Length, layout: () -> AnyLayout) -> (TraitQuery, AnyLayout) {
    return (TraitQuery(width: width, height: height), layout())
}

public func traitQuery(traitCollection: UITraitCollection, width: Length? = nil, height: Length? = nil, layout: @escaping () -> AnyLayout) -> (TraitQuery, AnyLayout) {
    return (TraitQuery(traitCollection: traitCollection, width: width, height: height), layout())
}
