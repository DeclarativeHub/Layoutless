//
//  Layoutless+UIKit.swift
//  Layoutless
//
//  Created by Srdan Rasic on 28/01/2018.
//  Copyright © 2018 Absurd Abstractions. All rights reserved.
//

import UIKit

// MARK: Protocol conformances

extension UIView: Anchorable {
}

extension UILayoutGuide: Anchorable {
}

extension UIView: LayoutProtocol {

    public func makeLayoutNode() -> UIView {
        return self
    }
}

extension UIView: LayoutNode {

    public func layout(in container: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        if let container = container as? UIStackView {
            container.addArrangedSubview(self)
        } else {
            container.addSubview(self)
        }
    }
}
