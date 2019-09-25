//
//  SearchViewModel.swift
//  WeatherAppSearch
//
//  Created by Matej Hetzel on 25/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared
import RxSwift

class SearchViewModel: ViewModelType {
    
    
    struct Input {
        var getDataSubject: ReplaySubject<Bool>
    }
    
    struct Output {
        var dataReadySubject: PublishSubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies {
        
    }
    
    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output {
        var disposables = [Disposable]()
        
        return Output(dataReadySubject: PublishSubject<Bool>(), disposables: disposables)
    }
    
}
