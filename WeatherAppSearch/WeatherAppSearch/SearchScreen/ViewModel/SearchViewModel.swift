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
    
    //MARK: Defining structs
    struct Input {
        var getDataSubject: ReplaySubject<String>
    }
    
    struct Output {
        var dataReadySubject: PublishSubject<Bool>
        var loaderSubject: PublishSubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies {
        let alamofireManager: LocationRepository
        let scheduler: SchedulerType
    }
    //MARK: Variables
    var input: Input!
    var output: Output!
    var dependencies: Dependencies!
    var dataForView: SearchDataModel?
    
    //MARK: Transform function
    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(getLocations(subject: input.getDataSubject))
        
        self.output = Output(dataReadySubject: PublishSubject<Bool>(), loaderSubject: PublishSubject<Bool>(), disposables: disposables)
        return output
    }
    
    init(dependencies: SearchViewModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: getLocations function
    func getLocations(subject: ReplaySubject<String>) -> Disposable {
        return subject
        .flatMap({[unowned self] bool -> Observable<SearchDataModel> in
            self.output.loaderSubject.onNext(true)
            return self.dependencies.alamofireManager.alamofireRequest(bool)
        })
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .subscribe(onNext: {[unowned self]  bool in
            self.output.dataReadySubject.onNext(true)
            self.dataForView = bool
            self.output.loaderSubject.onNext(false)
            print("d")
        })
    }
    
}
