//
//  AppDelegate.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {     
        setupUiOptions()
        return true
    }

    
    func setupUiOptions(){
        self.window = UIWindow()
        
        guard let window = self.window else { return }
        
        self.appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}

