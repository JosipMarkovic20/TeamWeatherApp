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
import Shared
@testable import TeamWeatherApp


class HomeScreenViewModelTest: QuickSpec {
    override func spec() {
        describe("setup Data"){
            var mainWeatherData: MainWeatherDataClass!
            let mockedAlamofireRepo = MockAlamofireRepository()
            var testScheduler: TestScheduler!
            var homeScreenViewModel: HomeScreenViewModel!
            let disposeBag = DisposeBag()
            beforeSuite {
                Cuckoo.stub(mockedAlamofireRepo) { mock in
                    let testBundle = Bundle(for: HomeScreenViewModelTest.self)
                    guard let path = testBundle.url(forResource: "MainWeatherData", withExtension: "json") else {return}
                    let dataFromLocation = try! Data(contentsOf: path)
                    let weather = try! JSONDecoder().decode(MainWeatherModel.self, from: dataFromLocation)
                    when(mock.alamofireRequest(any())).thenReturn(Observable.just(weather))
                    var dailyLocalArray = [DailyDataStruct]()
                    for daily in weather.daily.data {
                        dailyLocalArray.append(DailyDataStruct(temperatureHigh: daily.temperatureHigh, temperatureLow: daily.temperatureLow, time: daily.time))
                    }
                    mainWeatherData = MainWeatherDataClass(currently: CurrentlyStruct(time: weather.currently.time, summary: weather.currently.summary, icon: weather.currently.icon, temperature: weather.currently.temperature, humidity: weather.currently.humidity, pressure: weather.currently.pressure, windSpeed: weather.currently.windSpeed), daily: DailyStruct(data: dailyLocalArray))
                }
            }
            context("Initialize HomeScreenViewModel"){
                var dataReadySubject: TestableObserver<LayoutSetupEnum>!
                var loaderSubject: TestableObserver<Bool>!
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 0)
                    
                    homeScreenViewModel = HomeScreenViewModel(dependencies: HomeScreenViewModel.Dependencies(alamofireRepository: AlamofireRepository(), realmManager: RealmManager(), scheduler: ConcurrentDispatchQueueScheduler(qos: .background)))
                    
                    let output = homeScreenViewModel.transform(input: HomeScreenViewModel.Input(getSettingsSubject: PublishSubject<Bool>(), getDataSubject: ReplaySubject<Bool>.create(bufferSize: 1), getLocationsSubject: ReplaySubject<Bool>.create(bufferSize: 1), writeToRealmSubject: PublishSubject<WriteToRealmEnum>()))
                    
                    for disposable in output.disposables {
                        disposable.disposed(by: disposeBag)
                    }
                    
                    dataReadySubject = testScheduler.createObserver(LayoutSetupEnum.self)
                    
                    loaderSubject = testScheduler.createObserver(Bool.self)
                    homeScreenViewModel.output.dataIsReadySubject.subscribe(dataReadySubject).disposed(by: disposeBag)
                    
                    homeScreenViewModel.output.loaderSubject.subscribe(loaderSubject).disposed(by: disposeBag)
                    homeScreenViewModel.locationData = LocationsClass(lng: "17.39763", lat: "45.82176", name: "Virovitica", geoName: 0)
                }
                //MARK: Data Ready subject test
                it("Check if dataReady subject is triggered"){
                    testScheduler.start()
                    homeScreenViewModel.input.getDataSubject.onNext(true)
                    expect(dataReadySubject.events.count).toEventually(equal(1))
                }
                //MARK: Data test
                it("Check if viewModel is getting correct Data"){
                    testScheduler.start()
                    homeScreenViewModel.locationData = LocationsClass(lng: "17.39763", lat: "45.82176", name: "Virovitica", geoName: 0)
                    homeScreenViewModel.input.getDataSubject.onNext(true)
                    
                    expect(homeScreenViewModel.mainWeatherData?.daily.data.count).toEventually(equal(mainWeatherData.daily.data.count))
                    
                }
                //MARK: High and low temps Test
                it("Check if function returns a good High and Low temperatures"){
                    testScheduler.start()
                    
                    let temp = homeScreenViewModel.compareDayInData(weatherData: mainWeatherData)
                    expect(temp.0).toEventually(equal(11.5))
                    expect(temp.1).toEventually(equal(20.7))
                }
                //MARK: Background Image function test
                it("Check the state function"){
                    testScheduler.start()
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: mainWeatherData.currently.icon)
                    
                    expect(dataReadySubject.events[0].value.element).toEventually(equal(.rain))
                    expect(dataReadySubject.events.count).toEventually(equal(1))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "clear-day")
                    expect(dataReadySubject.events[1].value.element).toEventually(equal(.clearDay))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "clear-night")
                    expect(dataReadySubject.events[2].value.element).toEventually(equal(.clearNight))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "snow")
                    expect(dataReadySubject.events[3].value.element).toEventually(equal(.snow))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "sleet")
                    expect(dataReadySubject.events[4].value.element).toEventually(equal(.sleet))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "wind")
                    expect(dataReadySubject.events[5].value.element).toEventually(equal(.wind))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "fog")
                    expect(dataReadySubject.events[6].value.element).toEventually(equal(.fog))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "cloudy")
                    expect(dataReadySubject.events[7].value.element).toEventually(equal(.cloudy))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "partly-cloudy-day")
                    expect(dataReadySubject.events[8].value.element).toEventually(equal(.partlyCloudyDay))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "partly-cloudy-night")
                    expect(dataReadySubject.events[9].value.element).toEventually(equal(.partlyCloudyNight))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "hail")
                    expect(dataReadySubject.events[10].value.element).toEventually(equal(.hail))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "thunderstorm")
                    expect(dataReadySubject.events[11].value.element).toEventually(equal(.thunderstorm))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "tornado")
                    expect(dataReadySubject.events[12].value.element).toEventually(equal(.tornado))
                    
                    homeScreenViewModel.setupCurrentWeatherState(weatherDataIcon: "test Defaulta")
                    expect(dataReadySubject.events[13].value.element).toEventually(equal(.clearDay))
                    
                }
                //MARK: Loader Subject test
                it("check if loaderSubject is working"){
                    testScheduler.start()
                    
                    homeScreenViewModel.input.getDataSubject.onNext(true)
                    
                    expect(loaderSubject.events.count).toEventually(equal(2))
                    
                    expect(loaderSubject.events[0].value.element).toEventually(equal(true))
                    
                    expect(loaderSubject.events[1].value.element).toEventually(equal(false))
                }
                //MARK: Unit Conversion Function
                it("check if function is returning good values"){
                    testScheduler.start()
                    let outputMetric = homeScreenViewModel.convertUnits(unitType: .metric, data: mainWeatherData)
                    let outputImperial = homeScreenViewModel.convertUnits(unitType: .imperial, data: mainWeatherData)
                    
                    expect(outputImperial.currentTemperature).toEventually(equal("58°"))
                    expect(outputImperial.lowTemperature).toEventually(equal("52.7°F"))
                    expect(outputImperial.highTemperature).toEventually(equal("69.3°F"))
                    expect(outputImperial.windSpeed).toEventually(equal("1.0 mph"))
                    expect(outputImperial.pressure).toEventually(equal("1015 hpa"))
                    
                    expect(outputMetric.currentTemperature).toEventually(equal("14°"))
                    expect(outputMetric.lowTemperature).toEventually(equal("11.5°C"))
                    expect(outputMetric.highTemperature).toEventually(equal("20.7°C"))
                    expect(outputMetric.windSpeed).toEventually(equal("1.62 km/h"))
                    expect(outputMetric.pressure).toEventually(equal("1015 hpa"))
                    
                }
            }
        }
    }
}
