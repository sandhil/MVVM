//
//  AppDelegate.swift
//  MVVM
//
//  Created by sandhil eldhose on 11/9/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mvvmCoordinator = MVVMCoordinator(window: window)
        mvvmCoordinator.setInitialScreen()
        return true
    }
}

