 platform :ios, '11.0'

target 'TeamWeatherApp' do
  use_frameworks!

pod 'Alamofire'
pod 'RealmSwift'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Hue'
pod 'SwiftLocation'

def testing_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'Cuckoo'
    pod 'RxTest'
end

target 'TeamWeatherAppTests' do
    inherit! :search_paths
    testing_pods
end


end