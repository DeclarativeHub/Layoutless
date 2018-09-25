//
//  AppDelegate.swift
//  LayoutlessDemo
//
//  Created by Srdan Rasic on 23/06/2018.
//  Copyright © 2018 DeclarativeHub. All rights reserved.
//

import UIKit
import Layoutless

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: Window?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = Window(frame: UIScreen.main.bounds)
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

