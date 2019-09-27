//
//  SearchScreenCoordinator.swift
//  WeatherAppSearch
//
//  Created by Matej Hetzel on 25/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Shared
import RxSwift

public class SearchScreenCoordinator: Coordinator   {
    public var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController!
    let viewModel: SearchViewModel!
    public let viewController: SearchViewController
    
    
    public init(presenter: UINavigationController, searchBar: UISearchBar) {
        self.viewModel = SearchViewModel(dependencies: SearchViewModel.Dependencies(alamofireManager: LocationRepository(), scheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
        self.viewController = SearchViewController(viewModel: viewModel, searchBar: searchBar)
        self.presenter = presenter
    }
    
    public func start() {
        viewController.modalPresentationStyle = .overCurrentContext
        presenter.present(viewController, animated: true)
    }

   
}
