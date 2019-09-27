//
//  AppCoordinator.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import Shared


class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    var homeScreenCoordinator: HomeScreenCoordinator?
    let presenter: UINavigationController
    
    
    init(window: UIWindow){
        self.window = window
        self.presenter = UINavigationController()
    }
    
    
    func start() {
        self.homeScreenCoordinator = HomeScreenCoordinator(presenter: self.presenter)
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        
        guard let homeScreenCoordinator = self.homeScreenCoordinator else { return }
        self.store(coordinator: homeScreenCoordinator)
        presenter.navigationBar.isHidden = true
        homeScreenCoordinator.start()
    }
}
