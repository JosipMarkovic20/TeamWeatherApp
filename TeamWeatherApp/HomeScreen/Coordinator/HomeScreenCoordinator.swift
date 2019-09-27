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
    
    //MARK: Init
    init(presenter: UINavigationController){
        self.viewModel = HomeScreenViewModel(dependencies: HomeScreenViewModel.Dependencies(alamofireRepository: AlamofireRepository(), realmManager: RealmManager(), scheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
            
        self.viewController = HomeScreenViewController(viewModel: viewModel)
        self.presenter = presenter
        self.viewController.openSettingsDelegate = self
        self.viewController.openSearchDelegate = self
    }
    
    //MARK: Start
    func start() {
        presenter.navigationBar.barStyle = .black
        presenter.pushViewController(viewController, animated: true)
    }
}


extension HomeScreenCoordinator: ParentCoordinatorDelegate, CoordinatorDelegate, OpenSettingsDelegate{
    
    //MARK: Open settings
    func openSettings() {
        let settingsCoordinator = SettingsScreenCoordinator(presenter: presenter)
        settingsCoordinator.viewController.settingsDelegate = self.viewController
        self.store(coordinator: settingsCoordinator)
        settingsCoordinator.viewController.coordinatorDelegate = self
        settingsCoordinator.viewController.openLocationDelegate = self.viewController
        settingsCoordinator.start()
    }
    
    func childHasFinished(coordinator: Coordinator) {
        free(coordinator: coordinator)
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        childHasFinished(coordinator: self)
    }

}

extension HomeScreenCoordinator: OpenSearchDelegate{
    //MARK: Open search
    func openSearch(searchBar: UISearchBar) {
        let searchCoordinator = SearchScreenCoordinator(presenter: presenter, searchBar: searchBar)
        searchCoordinator.viewController.closingScreenDelegate = self.viewController
        searchCoordinator.viewController.coordinatorDelegate = self
        self.store(coordinator: searchCoordinator)
        searchCoordinator.start()
    }
    
}
