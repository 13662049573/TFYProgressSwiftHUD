//
//  SceneDelegate.swift
//  TFYProgressSwiftHUD
//
//  Created by 田风有 on 2021/4/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard scene is UIWindowScene,
              let rootViewController = window?.rootViewController,
              !(rootViewController is UINavigationController) else { return }

        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
    }

}
