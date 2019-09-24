//
//  HomeScreenCoordinator.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


class HomeScreenCoordinator: Coordinator{
    
    
    
    var childCoordinators: [Coordinator] = []
    let viewModel: HomeScreenViewModel
    let viewController: HomeScreenViewController
    
    init(){
        self.viewModel = HomeScreenViewModel()
        self.viewController = HomeScreenViewController(viewModel: viewModel)
    }
    
    
    func start() {
        
    }
    
 
}
