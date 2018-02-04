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

/// A decorator over child layout node that provides a way for the child to layout itself
/// with the respect to the parent it will eventually be added to.
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
