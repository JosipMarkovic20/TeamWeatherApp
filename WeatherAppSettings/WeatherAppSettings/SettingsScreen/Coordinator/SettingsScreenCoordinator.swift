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
import RxSwift

public class SettingsScreenCoordinator: Coordinator{
    
    //MARK: Properites
    public var childCoordinators: [Coordinator] = []
    public let viewController: SettingsScreenViewController
    let viewModel: SettingsScreenViewModel
    let presenter: UINavigationController
    
    //MARK: Init
    public init(presenter: UINavigationController){
        self.viewModel = SettingsScreenViewModel(dependencies: SettingsScreenViewModel.Dependencies(realmManager: RealmManager(), subscribeScheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
        self.viewController = SettingsScreenViewController(viewModel: self.viewModel)
        self.presenter = presenter
    }
    
    
    //MARK: Start
    public func start() {
        viewController.modalPresentationStyle = .overCurrentContext
        presenter.present(viewController, animated: true)
    }

}
