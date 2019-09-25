//
//  SettingsScreenCoordinator.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import Shared

public class SettingsScreenCoordinator: Coordinator{
    
    public var childCoordinators: [Coordinator] = []
    let viewController: SettingsScreenViewController
    let viewModel: SettingsScreenViewModel
    let presenter: UINavigationController
    
    public init(presenter: UINavigationController){
        self.viewModel = SettingsScreenViewModel(dependencies: SettingsScreenViewModel.Dependencies())
        self.viewController = SettingsScreenViewController(viewModel: self.viewModel)
        self.presenter = presenter
    }
    
    
    
    public func start() {
        viewController.modalPresentationStyle = .overCurrentContext
        presenter.present(viewController, animated: true)
    }

}
