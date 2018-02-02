//
//  LayoutProtocol.swift
//  Layoutless
//
//  Created by Srdan Rasic on 28/01/2018.
//  Copyright © 2018 Absurd Abstractions. All rights reserved.
//

import Foundation

public protocol AnyLayoutProtocol {
    func makeAnyLayoutNode() -> LayoutNode
}

public protocol LayoutProtocol: AnyLayoutProtocol {
    associatedtype LayoutNode: Layoutless.LayoutNode
    func makeLayoutNode() -> LayoutNode
}

extension LayoutProtocol {

    public func makeAnyLayoutNode() -> Layoutless.LayoutNode {
        return makeLayoutNode()
    }
}
