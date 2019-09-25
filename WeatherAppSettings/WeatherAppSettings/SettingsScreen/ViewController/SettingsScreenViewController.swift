//
//  SettingsScreenViewController.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SettingsScreenViewController: UIViewController{
    
    
    let viewModel: SettingsScreenViewModel
    
    
    init(viewModel: SettingsScreenViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .yellow
    }
    
}
