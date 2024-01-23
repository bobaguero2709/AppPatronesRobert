//
//  SceneDelegate.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/23/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        let splashViewController = SplashViewController()
        
        let navigationController = UINavigationController(rootViewController: splashViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
    }

}

