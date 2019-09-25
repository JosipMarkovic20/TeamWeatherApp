//
//  Coordinator.swift
//  Shared
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


public protocol Coordinator : class {
    var childCoordinators : [Coordinator] { get set }
    func start()
}


extension Coordinator {
    
    public func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    public func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
