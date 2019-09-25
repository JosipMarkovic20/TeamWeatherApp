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

public class SearchScreenCoordinator: Coordinator   {
    public var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController!
    let viewModel: SearchViewModel!
    let viewController: SearchViewController!
    
    
    public init(presenter: UINavigationController) {
        self.viewModel = SearchViewModel()
        self.viewController = SearchViewController(viewModel: viewModel)
        self.presenter = presenter
    }
    
    public func start() {
        viewController.modalPresentationStyle = .overCurrentContext
        presenter.present(viewController, animated: true)
    }

   
}
