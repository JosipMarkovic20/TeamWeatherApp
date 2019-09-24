//
//  HomeScreenCoordinator.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift


class HomeScreenCoordinator: Coordinator{
    
    
    
    var childCoordinators: [Coordinator] = []
    let viewModel: HomeScreenViewModel
    let viewController: HomeScreenViewController
    
    init(){
        self.viewModel = HomeScreenViewModel(dependencies: HomeScreenViewModel.Dependencies(alamofireRepository: AlamofireRepository(), scheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
            
        self.viewController = HomeScreenViewController(viewModel: viewModel)
    }
    
    
    func start() {
        
    }
    
 
}
