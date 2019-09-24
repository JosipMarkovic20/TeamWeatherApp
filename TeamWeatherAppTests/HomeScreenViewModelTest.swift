//
//  HomeViewModelTest.swift
//  TeamWeatherAppTests
//
//  Created by Matej Hetzel on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import Nimble
import Quick
import Cuckoo
@testable import TeamWeatherApp


class HomeScreenViewModelTest: QuickSpec {
    override func spec() {
        describe("setup Data"){
            var mainWeatherData: MainWeatherClass!
            let mockedAlamofireRepo = MockAlamofireRepository()
            var testScheduler: TestScheduler!
            var homeScreenViewModel: HomeScreenViewModel!
            let disposeBag = DisposeBag()
            beforeSuite {
                Cuckoo.stub(mockedAlamofireRepo) { mock in
                    let testBundle = Bundle(for: HomeScreenViewModelTest.self)
                    guard let path = testBundle.url(forResource: "MainWeatherData", withExtension: "json") else {return}
                    let dataFromLocation = try! Data(contentsOf: path)
                    let weather = try! JSONDecoder().decode(MainWeatherClass.self, from: dataFromLocation)
                    when(mock.alamofireRequest(any(), any())).thenReturn(Observable.just(weather))
                    
                    mainWeatherData = weather
                }
            }
            context("Initialize HomeScreenViewModel"){
                var dataReadySubject: TestableObserver<Bool>!
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 0)
                    
                    homeScreenViewModel = HomeScreenViewModel(dependencies: HomeScreenViewModel.Dependencies(alamofireRepository: AlamofireRepository(), scheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
                    
                    let output = homeScreenViewModel.transform(input: HomeScreenViewModel.Input(getSettingsSubject: ReplaySubject<Bool>.create(bufferSize: 1), getDataSubject: ReplaySubject<Bool>.create(bufferSize: 1), getLocationsSubject: ReplaySubject<Bool>.create(bufferSize: 1), writeToRealmSubject: PublishSubject<WriteToRealmEnum>()))
                    
                    for disposable in output.disposables {
                        disposable.disposed(by: disposeBag)
                    }
                    
                    dataReadySubject = testScheduler.createObserver(Bool.self)
                    homeScreenViewModel.output.dataIsReadySubject.subscribe(dataReadySubject).disposed(by: disposeBag)
                    
                }
                it("Check if dataReady subject is triggered"){
                    testScheduler.start()
                    
                    homeScreenViewModel.input.getDataSubject.onNext(true)
                expect(dataReadySubject.events.count).toEventually(equal(1))
                }
                it("Check if viewModel is getting correct Data"){
                    testScheduler.start()
                    homeScreenViewModel.input.getDataSubject.onNext(true)

                    expect(homeScreenViewModel.mainWeatherData?.daily.data.count).toEventually(equal(mainWeatherData.daily.data.count))

                }
                it("Check if function returns a good High and Low temperatures"){
                    testScheduler.start()
                    
                    let temp = homeScreenViewModel.compareDayInData(weatherData: mainWeatherData)
                    expect(temp.0).toEventually(equal(11.5))
                    expect(temp.1).toEventually(equal(20.7))
                }
            }
        }
    }
}
