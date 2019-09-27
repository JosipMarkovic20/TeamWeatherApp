//
//  HomeScreenCoordinator.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import Shared
import WeatherAppSettings
import WeatherAppSearch

class HomeScreenCoordinator: Coordinator{
    
    
    
    var childCoordinators: [Coordinator] = []
    let viewModel: HomeScreenViewModel
    let viewController: HomeScreenViewController
    let presenter: UINavigationController
    
    init(presenter: UINavigationController){
        self.viewModel = HomeScreenViewModel(dependencies: HomeScreenViewModel.Dependencies(alamofireRepository: AlamofireRepository(), realmManager: RealmManager(), scheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
            
        self.viewController = HomeScreenViewController(viewModel: viewModel)
        self.presenter = presenter
        self.viewController.openSettingsDelegate = self
        self.viewController.openSearchDelegate = self
    }
    
    
    func start() {
        presenter.navigationBar.barStyle = .black
        presenter.pushViewController(viewController, animated: true)
    }
}


extension HomeScreenCoordinator: OpenSettingsDelegate{
    
    func openSettings() {
        let settingsCoordinator = SettingsScreenCoordinator(presenter: presenter)
        settingsCoordinator.viewController.settingsDelegate = self.viewController
        settingsCoordinator.start()
    }

}

extension HomeScreenCoordinator: OpenSearchDelegate{
    func openSearch(searchBar: UISearchBar) {
        let searchCoordinator = SearchScreenCoordinator(presenter: presenter, searchBar: searchBar)
        searchCoordinator.viewController.closingScreenDelegate = self.viewController
        searchCoordinator.start()
    }
    
}
