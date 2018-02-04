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

open class Label: UILabel {

    /// A closure that gets called with `self` as an argument on `layoutSubviews`.
    /// Use it to configure styles that are derived from the view bounds.
    public var onLayout: (Label) -> Void = { _ in }

    public var intrinsicContentInsets: CGSize = .zero

    /// Text insets. Use it to add padding to the text within the label bounds.
    public var textInsets: UIEdgeInsets = .zero

    public var attributes: [NSAttributedStringKey: Any] = [:] {
        didSet {
            if let text = text {
                self.text = text
            }
        }
    }

    public var paragraphStyle: NSMutableParagraphStyle {
        get {
            if let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
                return paragraphStyle
            } else {
                let paragraphStyle = NSMutableParagraphStyle()
                attributes[.paragraphStyle] = paragraphStyle
                return paragraphStyle
            }
        }
        set {
            attributes[.paragraphStyle] = newValue
        }
    }

    @objc
    public dynamic var attributedLineSpacing: CGFloat {
        get {
            return paragraphStyle.lineSpacing
        }
        set {
            paragraphStyle.lineSpacing = newValue
        }
    }

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += textInsets.right + textInsets.left + intrinsicContentInsets.width * 2
        size.height += textInsets.top + textInsets.bottom + intrinsicContentInsets.height * 2
        return size
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        defineLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        defineLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        onLayout(self)
    }

    open override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }

    open override var text: String? {
        get {
            return attributedText?.string ?? super.text
        }
        set {
            if let newValue = newValue, attributes.count > 0 {
                attributedText = NSAttributedString(string: newValue, attributes: attributes)
            } else {
                super.text = newValue
            }
        }
    }

    open func setup() {
    }

    open func defineLayout() {
        _ = subviewsLayout.layout(in: self)
    }

    open var subviewsLayout: AnyLayout {
        return EmptyLayout()
    }
}
