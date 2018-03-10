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

import UIKit

@available(*, deprecated, renamed: "Length")
public typealias Dimension = Length

/// A type that represents a spatial dimension like width, height, inset, offset, etc.
/// Expressible by float or integer literal.
public enum Length: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {

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

extension Length {

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
