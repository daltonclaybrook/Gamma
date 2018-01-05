//
//  AppDelegate.swift
//  Gamma
//
//  Created by Dalton Claybrook on 1/3/18.
//  Copyright © 2018 Dalton Claybrook. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorViewController") as! ColorViewController
        let colors: [UIColor] = [
            .green, .red, .blue, .orange, .magenta
        ]
        viewController.configure(with: colors)
        window?.rootViewController = viewController
        return true
    }
}

