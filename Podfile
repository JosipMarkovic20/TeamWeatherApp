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
end

target 'TeamWeatherApp' do
  pods
end

target 'TeamWeatherAppTests' do
  inherit! :search_paths
  testing_pods
end
