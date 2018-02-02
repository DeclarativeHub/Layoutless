//
//  Layout.swift
//  Layoutless
//
//  Created by Srdan Rasic on 28/01/2018.
//  Copyright © 2018 Absurd Abstractions. All rights reserved.
//

public struct Layout<LayoutNode: Layoutless.LayoutNode>: LayoutProtocol {

    private let _generate: () -> LayoutNode

    public init(_ generate: @escaping () -> LayoutNode) {
        _generate = generate
    }

    public static func just(_ node: LayoutNode) -> Layout<LayoutNode> {
        return Layout { node }
    }

    public func makeLayoutNode() -> LayoutNode {
        return _generate()
    }
}
