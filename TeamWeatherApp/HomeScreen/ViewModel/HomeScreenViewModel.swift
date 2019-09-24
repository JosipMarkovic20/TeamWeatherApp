//
//  HomeScreenViewModel.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class HomeScreenViewModel: ViewModelType   {
    
    init(dependencies: HomeScreenViewModel.Dependencies){
        self.dependencies = dependencies
    }
    
    func transform(input: HomeScreenViewModel.Input) -> HomeScreenViewModel.Output {
        var disposables = [Disposable]()
        self.input = input
        
        disposables.append(getData(subject: input.getDataSubject))
        
        self.output = Output(dataIsReadySubject: PublishSubject(), locationIsMissingSubject: PublishSubject(), disposables: disposables)
        
        return output
    }
    
    struct Input {
        var requestSettingsSubject: ReplaySubject<Bool>
        var getDataSubject: ReplaySubject<Bool>
    }
    
    struct Output {
        var dataIsReadySubject: PublishSubject<Bool>
        var locationIsMissingSubject: PublishSubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies {
        var alamofireRepository: AlamofireRepository
        var scheduler: SchedulerType
    }
    
    var dependencies: Dependencies
    var input: Input!
    var output: Output!
    var mainWeatherData: MainWeatherClass?
    
    let units: String = "si"
    let location: String = "45.82176,17.39763"
    
    
    func getData(subject: ReplaySubject<Bool>) -> Disposable  {
        return subject
            .flatMap({[unowned self] bool -> Observable<MainWeatherClass> in
                let af = AlamofireRepository()
                return af.alamofireRequest(self.units, self.location)
            })
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: {[unowned self]  bool in
                self.output.dataIsReadySubject.onNext(true)
                self.mainWeatherData = bool
            }
        )
        
    }

}
