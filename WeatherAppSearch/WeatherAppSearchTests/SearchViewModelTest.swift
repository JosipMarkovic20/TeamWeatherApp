//
//  SearchViewModelTest.swift
//  WeatherAppSearchTests
//
//  Created by Matej Hetzel on 26/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import Nimble
import Quick
import Cuckoo
import Shared
@testable import WeatherAppSearch

class SearchViewModelTest: QuickSpec {
    override func spec() {
        describe("setup data"){
            var searchDataModel: SearchDataModel!
            let mockedAlamofireRepo = MockLocationRepository()
            var testScheduler: TestScheduler!
            var searchScreenViewModel: SearchViewModel!
            let disposeBag = DisposeBag()
            beforeSuite {
                Cuckoo.stub(mockedAlamofireRepo) { mock in
                    let testBundle = Bundle(for: SearchViewModelTest.self)
                    guard let path = testBundle.url(forResource: "SearchData", withExtension: "json") else {return}
                    let dataFromLocation = try! Data(contentsOf: path)
                    let locations = try! JSONDecoder().decode(SearchDataModel.self, from: dataFromLocation)
                    when(mock.alamofireRequest(any())).thenReturn(Observable.just(locations))
                    
                    searchDataModel = locations
                }
            }
            context("Initialize HomeScreenViewModel"){
            var dataReadySubject: TestableObserver<Bool>!
            beforeEach {
                testScheduler = TestScheduler(initialClock: 0)
                
                searchScreenViewModel = SearchViewModel(dependencies: SearchViewModel.Dependencies(alamofireManager: mockedAlamofireRepo, scheduler: testScheduler))
                
                let output = searchScreenViewModel.transform(input: SearchViewModel.Input(getDataSubject: ReplaySubject<String>.create(bufferSize: 1)))
                
                for disposable in output.disposables {
                    disposable.disposed(by: disposeBag)
                }
                
                dataReadySubject = testScheduler.createObserver(Bool.self)
                searchScreenViewModel.output.dataReadySubject.subscribe(dataReadySubject).disposed(by: disposeBag)
            }
                it("check if dataReady subject is triggered"){
                    testScheduler.start()
                    searchScreenViewModel.input.getDataSubject.onNext("true")
                    expect(dataReadySubject.events[0].value.element).toEventually(equal(true))
                }
                it("check if correct data is loaded into the viewModel"){
                    testScheduler.start()
                    searchScreenViewModel.input.getDataSubject.onNext("s")
                    expect(searchScreenViewModel.dataForView?.geonames.count).toEventually(equal(searchDataModel.geonames.count))
                }
        }
    }
}
}
