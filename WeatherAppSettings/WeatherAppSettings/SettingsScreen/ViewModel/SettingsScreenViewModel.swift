//
//  SettingsScreenViewModel.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Shared

class SettingsScreenViewModel: ViewModelType{

    struct Input{
    }
    
    struct Output{
    }
    
    struct Dependencies{
    }
    
    var dependencies: Dependencies
    var input: Input!
    var output: Output!
    
    
    init(dependencies: Dependencies){
        self.dependencies = dependencies
    }
    
    
    func transform(input: SettingsScreenViewModel.Input) -> SettingsScreenViewModel.Output {
        
        let output = Output()
        return output
    }
    
}
