//
//  Coordinator.swift
//  WeatherAppSearch
//
//  Created by Matej Hetzel on 25/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
public protocol Coordinator : class {
    var childCoordinators : [Coordinator] { get set }
    func start()
}


extension Coordinator {
    
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
