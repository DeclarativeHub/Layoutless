//
//  Layoutless.swift
//  Layoutless
//
//  Created by Srdan Rasic on 02/02/2018.
//  Copyright © 2018 Absurd Abstractions. All rights reserved.
//

import UIKit

// MARK: Hiererchy based layouts

extension LayoutProtocol where LayoutNode: Anchorable {

    public func layoutRelativeToDescendent(_ descendent: Anchorable, layout: @escaping (Anchorable, LayoutNode) -> Void) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            layout(descendent, node)
            return node
        }
    }

    public func layoutRelativeToParent(_ layout: @escaping (Anchorable, LayoutNode) -> Void) -> Layout<ChildNode<LayoutNode>> {
        return Layout {
            return ChildNode(self.makeLayoutNode(), layout: layout)
        }
    }

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

    public func sizing(toWidth width: Dimension) -> Layout<LayoutNode> {
        return sizing(toWidth: width, height: nil)
    }

    public func sizing(toHeight height: Dimension) -> Layout<LayoutNode> {
        return sizing(toWidth: nil, height: height)
    }

    public func sizing(toWidth width: Dimension? = nil, height: Dimension? = nil) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            if let width = width {
                width.constrainToConstant(node.widthAnchor).isActive = true
            }
            if let height = height {
                height.constrainToConstant(node.heightAnchor).isActive = true
            }
            return node
        }
    }

    public func sizingToParent(width: Dimension? = 0, height: Dimension? = 0) -> Layout<ChildNode<LayoutNode>> {
        return sizingToParent(width: width, height: height, relativeToSafeArea: false)
    }

    public func sizingToParent(width: Dimension? = 0, height: Dimension? = 0, relativeToSafeArea: Bool) -> Layout<ChildNode<LayoutNode>> {
        return layoutRelativeToParent(safeArea: relativeToSafeArea) { parent, node in
            if let width = width {
                width.constrain(node.widthAnchor, to: parent.widthAnchor).isActive = true
            }
            if let height = height {
                height.constrain(parent.heightAnchor, to: node.heightAnchor).isActive = true
            }
        }
    }

    public func constrainingAspectRatio(to aspectRatio: CGFloat) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            node.widthAnchor.constraint(equalTo: node.heightAnchor, multiplier: aspectRatio)
            return node
        }
    }
}

// MARK: Insetting

extension LayoutProtocol where LayoutNode: Anchorable {

    public func insetting(leftBy left: CGFloat, rightBy right: CGFloat, topBy top: CGFloat, bottomBy bottom: CGFloat) -> Layout<UIView> {
        return insetting(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    public func insetting(by insets: CGFloat) -> Layout<UIView> {
        return insetting(by: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
    }

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

    public func centeringVerticallyInParent(offset: Dimension, relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return centeringInParent(xOffset: nil, yOffset: offset, relativeToSafeArea: relativeToSafeArea)
    }

    public func centeringHorizontallyInParent(offset: Dimension, relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return centeringInParent(xOffset: offset, yOffset: nil, relativeToSafeArea: relativeToSafeArea)
    }

    public func centeringInParent(xOffset: Dimension? = 0, yOffset: Dimension? = 0) -> Layout<ChildNode<LayoutNode>> {
        return centeringInParent(xOffset: xOffset, yOffset: yOffset, relativeToSafeArea: false)
    }

    public func centeringInParent(xOffset: Dimension? = 0, yOffset: Dimension? = 0, relativeToSafeArea: Bool) -> Layout<ChildNode<LayoutNode>> {
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

    public func fillingParent(relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: 0, right: 0, top: 0, bottom: 0, relativeToSafeArea: relativeToSafeArea)
    }

    public func fillingParent(insets: CGFloat, relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: .exactly(insets), right: .exactly(insets), top: .exactly(insets), bottom: .exactly(insets), relativeToSafeArea: relativeToSafeArea)
    }

    public func fillingParent(insets: UIEdgeInsets, relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: .exactly(insets.left), right: .exactly(insets.right), top: .exactly(insets.top), bottom: .exactly(insets.bottom), relativeToSafeArea: relativeToSafeArea)
    }

    public func fillingParent(left: Dimension, right: Dimension, top: Dimension, bottom: Dimension, relativeToSafeArea: Bool = false) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: left, right: right, top: top, bottom: bottom, relativeToSafeArea: relativeToSafeArea)
    }

    public func stickingToParentEdges(left: Dimension? = nil, right: Dimension? = nil, top: Dimension? = nil, bottom: Dimension? = nil) -> Layout<ChildNode<LayoutNode>> {
        return stickingToParentEdges(left: left, right: right, top: top, bottom: bottom, relativeToSafeArea: false)
    }

    public func stickingToParentEdges(left: Dimension? = nil, right: Dimension? = nil, top: Dimension? = nil, bottom: Dimension? = nil, relativeToSafeArea: Bool) -> Layout<ChildNode<LayoutNode>> {
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

    public func scrolling(direction: UILayoutConstraintAxis, configure: @escaping (UIScrollView) -> Void = { _ in }) -> Layout<ChildNode<UIScrollView>> {
        return scrolling(scrollViewType: UIScrollView.self, direction: direction, configure: configure)
    }
}

// MARK: Embedding

extension LayoutProtocol {

    public func emedding<View: UIView>(in view: View) -> Layout<View> {
        return Layout {
            self.makeLayoutNode().layout(in: view)
            return view
        }
    }
}

extension LayoutProtocol where LayoutNode: UIView {

    public func addingSubview(_ subview: LayoutNode) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            subview.layout(in: node)
            return node
        }
    }

    public func addingLayout(_ layout: AnyLayoutProtocol) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            layout.makeAnyLayoutNode().layout(in: node)
            return node
        }
    }
}

// MARK: Stacking

public func stack(_ views: [AnyLayoutProtocol], axis: UILayoutConstraintAxis, spacing: CGFloat = 0, distribution: UIStackViewDistribution = .fill, alignment: UIStackViewAlignment = .fill) -> Layout<UIStackView> {
    return Layout {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        views.forEach { $0.makeAnyLayoutNode().layout(in: stackView) }
        return stackView
    }
}

public func stack(_ axis: UILayoutConstraintAxis, spacing: CGFloat = 0, distribution: UIStackViewDistribution = .fill, alignment: UIStackViewAlignment = .fill) -> ((AnyLayoutProtocol...) -> Layout<UIStackView>) {
    return { (views: AnyLayoutProtocol...) -> Layout<UIStackView> in
        return stack(views, axis: axis, spacing: spacing, distribution: distribution, alignment: alignment)
    }
}

// MARK: Grouping

public class LayoutGroup: LayoutNode {

    private let layouts: [AnyLayoutProtocol]

    public init(_ layouts: [AnyLayoutProtocol]) {
        self.layouts = layouts
    }

    public func layout(in container: UIView) {
        layouts.forEach { $0.makeAnyLayoutNode().layout(in: container) }
    }
}

public func group(_ layouts: [AnyLayoutProtocol]) -> Layout<LayoutGroup> {
    return Layout {
        return LayoutGroup(layouts)
    }
}

public func group(_ layouts: AnyLayoutProtocol...) -> Layout<LayoutGroup> {
    return group(layouts)
}

// MARK: Configuring intrinsic size behaviour

extension LayoutProtocol where LayoutNode: UIView {

    public func settingHugging(_ priority: UILayoutPriority, axis: UILayoutConstraintAxis) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            node.setContentHuggingPriority(priority, for: axis)
            return node
        }
    }

    public func settingCompressionResistance(_ priority: UILayoutPriority, axis: UILayoutConstraintAxis) -> Layout<LayoutNode> {
        return Layout {
            let node = self.makeLayoutNode()
            node.setContentCompressionResistancePriority(priority, for: axis)
            return node
        }
    }
}

// MARK: Spacing views

public func verticalSpacing(_ height: CGFloat, required: Bool = true, priority: UILayoutPriority = .required) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    if required {
        let constraint = view.heightAnchor.constraint(equalToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
    } else {
        let constraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
    }
    return view
}

public func horizontalSpacing(_ width: CGFloat, required: Bool = true, priority: UILayoutPriority = .required) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    if required {
        let constraint = view.widthAnchor.constraint(equalToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
    } else {
        let constraint = view.widthAnchor.constraint(lessThanOrEqualToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
    }
    return view
}
