//
//  AppCoordinator.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit

//AppCoordinator which creates our main screen coordinator and sets it as root viewController
class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    var homeScreenCoordinator: HomeScreenCoordinator?
    
    
    init(window: UIWindow){
        self.window = window
    }
    
    
    func start() {
        self.homeScreenCoordinator = HomeScreenCoordinator()
        window.rootViewController = homeScreenCoordinator?.viewController
        window.makeKeyAndVisible()
        
        guard let homeScreenCoordinator = self.homeScreenCoordinator else { return }
        self.store(coordinator: homeScreenCoordinator)
        homeScreenCoordinator.start()
    }
}
