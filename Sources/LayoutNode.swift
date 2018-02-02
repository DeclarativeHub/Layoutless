//
//  LayoutableInContainer.swift
//  Layoutless
//
//  Created by Srdan Rasic on 28/01/2018.
//  Copyright © 2018 Absurd Abstractions. All rights reserved.
//

import Foundation

public protocol LayoutNode {
    func layout(in container: UIView)
}
