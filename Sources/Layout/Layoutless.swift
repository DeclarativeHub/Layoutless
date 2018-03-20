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

// MARK: Hiererchy based layout

extension LayoutProtocol where LayoutNode: Anchorable {

    /// Provides a way to layout a node with respect to the given descendent node.
    public func layoutRelativeToDescendent(_ descendent: Anchorable, layout: @escaping (Anchorable, LayoutNode) -> Void) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            layout(descendent, node)
            return node
        }
    }

    /// Provides a way to layout a node with respect to the node's eventual parent node.
    public func layoutRelativeToParent(_ layout: @escaping (Anchorable, LayoutNode) -> Void) -> Layout<ChildNode<LayoutNode>> {
        return Layout {
            return ChildNode(self.makeLayoutNode(), layout: layout)
        }
    }

    /// Provides a way to layout a node with respect to the node's eventual parent node or its safe area.
    public func layoutRelativeToParent(safeArea: Bool, layout: @escaping (Anchorable, LayoutNode) -> Void) -> Layout<ChildNode<LayoutNode>> {
        return Layout {
            return ChildNode(self.makeLayoutNode()) { parent, node in
                if #available(iOS 11.0, *), safeArea {
                    layout(parent.safeAreaLayoutGuide, node)
                } else {
                    layout(parent, node)
                }
            }
        }
    }
}

// MARK: Sizing

extension LayoutProtocol where LayoutNode: Anchorable {

    /// Constrain the node to the given width.
    public func sizing(toWidth width: Length) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            width.constrainToConstant(node.widthAnchor).isActive = true
            return node
        }
    }

    /// Constrain the node to the given height.
    public func sizing(toHeight height: Length) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            height.constrainToConstant(node.heightAnchor).isActive = true
            return node
        }
    }

    /// Constrain the node to the given width and height.
    public func sizing(toWidth width: Length, height: Length) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            width.constrainToConstant(node.widthAnchor).isActive = true
            height.constrainToConstant(node.heightAnchor).isActive = true
            return node
        }
    }

    /// Constrain the node width and/or height to node's parent width and/or heigh with an offset.
    /// Default offset is 0. Pass `nil` for a given dimension offset to not constrain that dimension.
    public func sizingToParent(widthOffset: Length? = 0, heightOffset: Length? = 0) -> Layout<ChildNode<LayoutNode>> {
        return sizingToParent(widthOffset: widthOffset, heightOffset: heightOffset, relativeToSafeArea: false)
    }

    /// Constrain the node width and/or height to node's parent width and/or heigh with an offset.
    /// Default offset is 0. Pass `nil` for a given dimension offset to not constrain that dimension.
    public func sizingToParent(widthOffset: Length? = 0, heightOffset: Length? = 0, relativeToSafeArea: Bool) -> Layout<ChildNode<LayoutNode>> {
        return layoutRelativeToParent(safeArea: relativeToSafeArea) { parent, node in
            if let widthOffset = widthOffset {
                widthOffset.constrain(node.widthAnchor, to: parent.widthAnchor).isActive = true
            }
            if let heightOffset = heightOffset {
                heightOffset.constrain(parent.heightAnchor, to: node.heightAnchor).isActive = true
            }
        }
    }

    /// Constrain node's width to height using the given aspect ratio.
    public func constrainingAspectRatio(to aspectRatio: CGFloat) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            node.widthAnchor.constraint(equalTo: node.heightAnchor, multiplier: aspectRatio).isActive = true
            return node
        }
    }
}

// MARK: Insetting

extension LayoutProtocol where LayoutNode: Anchorable {

    /// Inset the node by wrapping it in a dummy view and filling it using the given insets.
    public func insetting(leftBy left: CGFloat, rightBy right: CGFloat, topBy top: CGFloat, bottomBy bottom: CGFloat) -> Layout<UIView> {
        return insetting(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    /// Inset the node by wrapping it in a dummy view and filling it using the given insets.
    public func insetting(by insets: CGFloat) -> Layout<UIView> {
        return insetting(by: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
    }

    /// Inset the node by wrapping it in a dummy view and filling it using the given insets.
    public func insetting(by insets: UIEdgeInsets) -> Layout<UIView> {
        return Layout {
            let container = UIView()
            self.fillingParent(insets: insets).makeLayoutNode().layout(in: container)
            return container
        }
    }
}

// MARK: Centering in parent

extension LayoutProtocol where LayoutNode: Anchorable {

    /// Center the node vertically within the parent using the given y-offset. Default offset is 0.
    public func centeringVerticallyInParent(offset: Length = 0, relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return centeringInParent(xOffset: nil, yOffset: offset, relativeToSafeArea: relativeToSafeArea)
    }

    /// Center the node horizontally within the parent using the given x-offset. Default offset is 0.
    public func centeringHorizontallyInParent(offset: Length = 0, relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return centeringInParent(xOffset: offset, yOffset: nil, relativeToSafeArea: relativeToSafeArea)
    }

    /// Center the node vertically and horizontally within the parent using the given x- and y- offsets. Default offsets are 0.
    public func centeringInParent(xOffset: Length? = 0, yOffset: Length? = 0) -> Layout<ChildNode<LayoutNode>> {
        return centeringInParent(xOffset: xOffset, yOffset: yOffset, relativeToSafeArea: false)
    }

    /// Center the node vertically and horizontally within the parent using the given x- and y- offsets. Default offsets are 0.
    public func centeringInParent(xOffset: Length? = 0, yOffset: Length? = 0, relativeToSafeArea: Bool) -> Layout<ChildNode<LayoutNode>> {
        return layoutRelativeToParent(safeArea: relativeToSafeArea) { parent, node in
            if let xOffset = xOffset {
                xOffset.constrain(node.centerXAnchor, to: parent.centerXAnchor).isActive = true
            }
            if let yOffset = yOffset {
                yOffset.constrain(node.centerYAnchor, to: parent.centerYAnchor).isActive = true
            }
        }
    }
}

// MARK: Filling and sticking to parent

extension LayoutProtocol where LayoutNode: Anchorable {

    /// Constrain all four node's edges to the parent node's edges using the given insets.
    public func fillingParent(insets: CGFloat, relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: .exactly(insets), right: .exactly(insets), top: .exactly(insets), bottom: .exactly(insets), relativeToSafeArea: relativeToSafeArea)
    }

    /// Constrain all four node's edges to the parent node's edges using the given insets.
    public func fillingParent(insets: UIEdgeInsets, relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: .exactly(insets.left), right: .exactly(insets.right), top: .exactly(insets.top), bottom: .exactly(insets.bottom), relativeToSafeArea: relativeToSafeArea)
    }

    /// Constrain all four node's edges to the parent node's edges using the given insets. Default insets are 0.
    public func fillingParent(insets: (left: Length, right: Length, top: Length, bottom: Length) = (0, 0, 0, 0)) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: insets.left, right: insets.right, top: insets.top, bottom: insets.bottom, relativeToSafeArea: false)
    }

    /// Constrain all four node's edges to the parent node's edges using the given insets. Default insets are 0.
    public func fillingParent(insets: (left: Length, right: Length, top: Length, bottom: Length) = (0, 0, 0, 0), relativeToSafeArea: Bool) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: insets.left, right: insets.right, top: insets.top, bottom: insets.bottom, relativeToSafeArea: relativeToSafeArea)
    }

    /// Constrain node's edges to the parent node's edges using the given insets. Only edges with non-nil insets will be constrained! Default insets are nil.
    public func stickingToParentEdges(left: Length? = nil, right: Length? = nil, top: Length? = nil, bottom: Length? = nil) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: left, right: right, top: top, bottom: bottom, relativeToSafeArea: false)
    }

    /// Constrain node's edges to the parent node's edges using the given insets. Only edges with non-nil insets will be constrained! Default insets are nil.
    public func stickingToParentEdges(left: Length? = nil, right: Length? = nil, top: Length? = nil, bottom: Length? = nil, relativeToSafeArea: Bool) -> Layout<ChildNode<LayoutNode>> {
        return layoutRelativeToParent(safeArea: relativeToSafeArea) { parent, node in
            if let left = left {
                left.constrain(node.leftAnchor, to: parent.leftAnchor).isActive = true
            }
            if let right = right {
                right.constrain(parent.rightAnchor, to: node.rightAnchor).isActive = true
            }
            if let top = top {
                top.constrain(node.topAnchor, to: parent.topAnchor).isActive = true
            }
            if let bottom = bottom {
                bottom.constrain(parent.bottomAnchor, to: node.bottomAnchor).isActive = true
            }
        }
    }
}

// MARK: Scrolling

extension LayoutProtocol where LayoutNode: Anchorable {

    public func scrolling<ScrollView: UIScrollView>(scrollViewType: ScrollView.Type, layoutToScrollViewParent: @escaping (Layout<LayoutNode>) -> Layout<ChildNode<LayoutNode>>, configure: @escaping (ScrollView) -> Void = { _ in }) -> Layout<ChildNode<ScrollView>> {
        return Layout {
            return ChildNode(ScrollView()) { container, scrollView in
                scrollView.delaysContentTouches = false
                configure(scrollView)
                let layoutNode = self.fillingParent().makeLayoutNode()
                layoutToScrollViewParent(Layout.just(layoutNode.child)).makeLayoutNode().layout(in: container)
                layoutNode.layout(in: scrollView)
            }
        }
    }

    /// Embed the node in a custom scroll view that should scroll in the given direction. Optionally pass in the closure to setup the scroll view.
    public func scrolling<ScrollView: UIScrollView>(scrollViewType: ScrollView.Type, direction: UILayoutConstraintAxis, configure: @escaping (UIScrollView) -> Void = { _ in }) -> Layout<ChildNode<ScrollView>> {
        switch direction {
        case .vertical:
            return scrolling(
                scrollViewType: scrollViewType,
                layoutToScrollViewParent: { $0.stickingToParentEdges(left: 0, right: 0) },
                configure: configure
            )
        case .horizontal:
            return scrolling(
                scrollViewType: scrollViewType,
                layoutToScrollViewParent: { $0.stickingToParentEdges(top: 0, bottom: 0) },
                configure: configure
            )
        }
    }

    /// Embed the node in a scroll view that should scroll in the given direction. Optionally pass in the closure to setup the scroll view.
    public func scrolling(_ direction: UILayoutConstraintAxis, configure: @escaping (UIScrollView) -> Void = { _ in }) -> Layout<ChildNode<UIScrollView>> {
        return scrolling(scrollViewType: UIScrollView.self, direction: direction, configure: configure)
    }
}

// MARK: Embedding

extension LayoutProtocol {

    @available(*, deprecated, renamed: "embedding(in:)")
    public func emedding<View: UIView>(in view: View) -> Layout<View> {
        return embedding(in: view)
    }

    /// Embed the node in the given view and return the layout that has the given view as a root node.
    public func embedding<View: UIView>(in view: View) -> Layout<View> {
        return Layout {
            self.makeLayoutNode().layout(in: view)
            return view
        }
    }
}

extension LayoutProtocol where LayoutNode: UIView {

    /// Add the given view as a subview of the node and return the layout that has the node as a root node.
    public func addingSubview(_ subview: LayoutNode) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            subview.layout(in: node)
            return node
        }
    }

    /// Layout the given layout within the node and return the layout that has the node as a root node.
    public func addingLayout(_ layout: AnyLayout) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            layout.makeAnyLayoutNode().layout(in: node)
            return node
        }
    }
}

// MARK: Stacking

/// Stack an array of views in a stack view.
public func stack(_ views: [AnyLayout], axis: UILayoutConstraintAxis, spacing: CGFloat = 0, distribution: UIStackViewDistribution = .fill, alignment: UIStackViewAlignment = .fill) -> Layout<UIStackView> {
    return Layout {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        views.forEach { $0.layout(in: stackView) }
        return stackView
    }
}

/// Stack an array of views in a stack view.
public func stack(_ axis: UILayoutConstraintAxis, spacing: CGFloat = 0, distribution: UIStackViewDistribution = .fill, alignment: UIStackViewAlignment = .fill) -> ((AnyLayout...) -> Layout<UIStackView>) {
    return { (views: AnyLayout...) -> Layout<UIStackView> in
        return stack(views, axis: axis, spacing: spacing, distribution: distribution, alignment: alignment)
    }
}

// MARK: Grouping

public class LayoutGroup: LayoutNode {

    private let layouts: [AnyLayout]

    public init(_ layouts: [AnyLayout]) {
        self.layouts = layouts
    }

    public func layout(in container: UIView) {
        layouts.forEach { $0.makeAnyLayoutNode().layout(in: container) }
    }
}

/// Group an array of layouts that should be laid out in the same container.
public func group(_ layouts: [AnyLayout]) -> Layout<LayoutGroup> {
    return Layout {
        return LayoutGroup(layouts)
    }
}

/// Group an array of layouts that should be laid out in the same container.
public func group(_ layouts: AnyLayout...) -> Layout<LayoutGroup> {
    return group(layouts)
}

// MARK: Configuring intrinsic size behaviour

extension LayoutProtocol where LayoutNode: UIView {

    /// Modify the node's hugging priority for the given axis.
    public func settingHugging(_ priority: UILayoutPriority, axis: UILayoutConstraintAxis) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            node.setContentHuggingPriority(priority, for: axis)
            return node
        }
    }

    /// Modify the node's compression resistance priority for the given axis.
    public func settingCompressionResistance(_ priority: UILayoutPriority, axis: UILayoutConstraintAxis) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            node.setContentCompressionResistancePriority(priority, for: axis)
            return node
        }
    }
}

// MARK: Spacing views

/// An invisible dummy view constrained to the given height.
public func verticalSpacing(_ height: Length, priority: UILayoutPriority = .required) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    let constraint = height.constrainToConstant(view.heightAnchor)
    constraint.priority = priority
    constraint.isActive = true
    return view
}

/// An invisible dummy view constrained to the given width.
public func horizontalSpacing(_ width: Length, priority: UILayoutPriority = .required) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    let constraint = width.constrainToConstant(view.widthAnchor)
    constraint.priority = priority
    constraint.isActive = true
    return view
}
