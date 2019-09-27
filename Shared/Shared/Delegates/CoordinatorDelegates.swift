//
//  CoordinatorDelegates.swift
//  Shared
//
//  Created by Josip Marković on 27/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


public protocol ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator)
}

public protocol CoordinatorDelegate: class {
    func viewControllerHasFinished()
}
