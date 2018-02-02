//
//  Dimension.swift
//  Layoutless
//
//  Created by Srdan Rasic on 28/01/2018.
//  Copyright © 2018 Absurd Abstractions. All rights reserved.
//

public enum Dimension: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {

    case exactly(CGFloat)
    case greaterThanOrEqualTo(CGFloat)
    case lessThanOrEqualTo(CGFloat)

    public init(floatLiteral value: Float) {
        self = .exactly(CGFloat(value))
    }

    public init(integerLiteral value: Int) {
        self = .exactly(CGFloat(value))
    }

    public var cgFloatValue: CGFloat {
        switch self {
        case .exactly(let value):
            return value
        case .greaterThanOrEqualTo(let value):
            return value
        case .lessThanOrEqualTo(let value):
            return value
        }
    }
}

import UIKit

extension Dimension {

    func constrain<Type>(_ lhs: NSLayoutAnchor<Type>, to rhs: NSLayoutAnchor<Type>) -> NSLayoutConstraint {
        switch self {
        case .exactly(let value):
            return lhs.constraint(equalTo: rhs, constant: CGFloat(value))
        case .lessThanOrEqualTo(let value):
            return lhs.constraint(lessThanOrEqualTo: rhs, constant: CGFloat(value))
        case .greaterThanOrEqualTo(let value):
            return lhs.constraint(greaterThanOrEqualTo: rhs, constant: CGFloat(value))
        }
    }

    func constrainToConstant(_ lhs: NSLayoutDimension) -> NSLayoutConstraint {
        switch self {
        case .exactly(let value):
            return lhs.constraint(equalToConstant: CGFloat(value))
        case .lessThanOrEqualTo(let value):
            return lhs.constraint(lessThanOrEqualToConstant: CGFloat(value))
        case .greaterThanOrEqualTo(let value):
            return lhs.constraint(greaterThanOrEqualToConstant: CGFloat(value))
        }
    }
}
