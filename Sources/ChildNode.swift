//
//  ChildNode.swift
//  Layoutless
//
//  Created by Srdan Rasic on 02/02/2018.
//  Copyright © 2018 Absurd Abstractions. All rights reserved.
//

public class ChildNode<LayoutNode: Layoutless.LayoutNode>: Layoutless.LayoutNode, Anchorable where LayoutNode: Anchorable {

    public let child: LayoutNode
    public let layout: (UIView) -> Void

    public init(_ child: LayoutNode, layout: @escaping (UIView, LayoutNode) -> Void) {
        self.child = child
        self.layout = { container in
            child.layout(in: container)
            layout(container, child)
        }
    }

    public func layout(in container: UIView) {
        return layout(container)
    }

    public var leadingAnchor: NSLayoutXAxisAnchor { return child.leadingAnchor }
    public var trailingAnchor: NSLayoutXAxisAnchor { return child.trailingAnchor }
    public var leftAnchor: NSLayoutXAxisAnchor { return child.leftAnchor }
    public var rightAnchor: NSLayoutXAxisAnchor { return child.rightAnchor }
    public var topAnchor: NSLayoutYAxisAnchor { return child.topAnchor }
    public var bottomAnchor: NSLayoutYAxisAnchor { return child.bottomAnchor }
    public var widthAnchor: NSLayoutDimension { return child.widthAnchor }
    public var heightAnchor: NSLayoutDimension { return child.heightAnchor }
    public var centerXAnchor: NSLayoutXAxisAnchor { return child.centerXAnchor }
    public var centerYAnchor: NSLayoutYAxisAnchor { return child.centerYAnchor }
}
