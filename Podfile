platform :ios, '11.0'

use_frameworks!

workspace 'TeamWeatherApp'

def pods
  pod 'Alamofire'
  pod 'RealmSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Hue'
  pod 'SwiftLocation'
  pod 'SnapKit'
end

def testing_pods
  pod 'Quick'
  pod 'Nimble'
  pod 'Cuckoo'
  pod 'RxTest'
end

target 'WeatherAppSettings' do
  project 'WeatherAppSettings/WeatherAppSettings.project'
  pods
  target 'WeatherAppSettingsTests' do
    testing_pods
  end
end

target 'WeatherAppSearch' do
  project 'WeatherAppSearch/WeatherAppSearch.project'
  pods
  target 'WeatherAppSearchTests' do
    testing_pods
  end
end

target 'Shared' do
  project 'Shared/Shared.project'
  pods
end

target 'TeamWeatherApp' do
  pods
end

target 'TeamWeatherAppTests' do
  testing_pods
end
