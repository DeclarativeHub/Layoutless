//
//  Deprecations.swift
//  Layoutless
//
//  Created by Srdan Rasic on 06/06/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import Foundation
import UIKit

@available(*, deprecated, renamed: "UI.View")
public typealias View = UI.View

@available(*, deprecated, renamed: "UI.Control")
public typealias Control = UI.Control

@available(*, deprecated, renamed: "UI.Label")
public typealias Label = UI.Label

@available(*, deprecated, renamed: "UI.Button")
public typealias Button = UI.Button

@available(*, deprecated, renamed: "UI.TextField")
public typealias TextField = UI.TextField

@available(*, deprecated, renamed: "UI.ImageView")
public typealias ImageView = UI.ImageView

@available(*, deprecated, renamed: "UI.TableViewCell")
public typealias TableViewCell = UI.TableViewCell

@available(*, deprecated, renamed: "UI.CollectionViewCell")
public typealias CollectionViewCell = UI.CollectionViewCell

@available(*, deprecated, renamed: "UI.ViewController")
public typealias ViewController = UI.ViewController

@available(*, deprecated, renamed: "UI.Window")
public typealias Window = UI.Window
