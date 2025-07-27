//
//  AppDelegate.swift
//  example
//
//  Created by Alon Shprung on 27/07/2025.
//

import UIKit
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider
 
@main
class AppDelegate: RCTAppDelegate {
  var window: UIWindow?
  var navController: UINavigationController?

  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let bridge = RCTBridge(delegate: self, launchOptions: launchOptions)
    let rootView = RCTRootView(bridge: bridge!, moduleName: "example", initialProperties: nil)

    let window = UIWindow(frame: UIScreen.main.bounds)
    let rootViewController = UIViewController()
    rootViewController.view = rootView

    let navController = UINavigationController(rootViewController: rootViewController)
    navController.setNavigationBarHidden(true, animated: false)
    window.rootViewController = navController
    window.makeKeyAndVisible()

    self.window = window
    self.navController = navController

    return true
  }
 
  override func sourceURL(for bridge: RCTBridge) -> URL? {
    self.bundleURL()
  }
 
  override func bundleURL() -> URL? {
#if DEBUG
    RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
#else
    Bundle.main.url(forResource: "main", withExtension: "jsbundle")
#endif
  }
}
