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
        let portrait = button.sizing(toWidth: 200).fillingParent(insets: 30).embedding(in: rect).centeringInParent()
        let landscape = stack(.horizontal)(button, rect.sizing(toWidth: 30).sizing(toHeight: 20)).centeringInParent()

        return traitCollectionLayoutSet([
            UITraitCollection(verticalSizeClass: .regular): portrait,
            UITraitCollection(verticalSizeClass: .compact): landscape
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        NotificationCenter.default.post(name: .didChangeWindowTraitCollection, object: nil)
        print("did change to",  traitCollection)
    }
}

