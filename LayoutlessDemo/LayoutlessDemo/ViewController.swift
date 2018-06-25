//
//  ViewController.swift
//  LayoutlessDemo
//
//  Created by Srdan Rasic on 23/06/2018.
//  Copyright © 2018 DeclarativeHub. All rights reserved.
//

import UIKit
import Layoutless

class ViewController: Layoutless.ViewController {

    let button = UIButton()
    let rect = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .red
        rect.backgroundColor = .green
    }

    override var subviewsLayout: AnyLayout {

        let rectLayout = layoutSet(
            traitQuery(width: .greaterThanOrEqualTo(1001)) {
                rect.sizing(toWidth: 60).sizing(toHeight: 10)
            },
            traitQuery(width: .lessThanOrEqualTo(1000)) {
                rect.sizing(toWidth: 30).sizing(toHeight: 20)
            }
        )

        let portrait: AnyLayout = button.sizing(toWidth: 200).fillingParent(insets: 30).embedding(in: rect).centeringInParent()
        let landscape: AnyLayout = stack(.horizontal)(button, rectLayout).centeringInParent()

        return layoutSet(
            traitQuery(traitCollection: UITraitCollection(horizontalSizeClass: .compact)) { portrait },
            traitQuery(traitCollection: UITraitCollection(horizontalSizeClass: .regular)) { landscape }
        )
    }
}

