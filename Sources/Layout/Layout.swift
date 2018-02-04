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

/// A type that represents layout calculation as a closure.
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

/// A layout of nothing.
public func EmptyLayout() -> Layout<EmptyLayoutNode> {
    return Layout.just(EmptyLayoutNode())
}

/// A node that does not have any content.
public struct EmptyLayoutNode: LayoutNode {
    public init() {}
    public func layout(in container: UIView) {}
}
