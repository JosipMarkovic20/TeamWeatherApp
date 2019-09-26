// MARK: - Mocks generated from file: WeatherAppSearch/Networking/Repository/LocationRepository.swift at 2019-09-26 11:38:12 +0000

//
//  LocationRepository.swift
//  WeatherAppSearch
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//
import Cuckoo
@testable import WeatherAppSearch

import Foundation
import RxSwift
import Shared


 class MockLocationRepository: LocationRepository, Cuckoo.ClassMock {
    
     typealias MocksType = LocationRepository
    
     typealias Stubbing = __StubbingProxy_LocationRepository
     typealias Verification = __VerificationProxy_LocationRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: LocationRepository?

     func enableDefaultImplementation(_ stub: LocationRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func alamofireRequest(_ location: String) -> Observable<SearchDataModel> {
        
    return cuckoo_manager.call("alamofireRequest(_: String) -> Observable<SearchDataModel>",
            parameters: (location),
            escapingParameters: (location),
            superclassCall:
                
                super.alamofireRequest(location)
                ,
            defaultCall: __defaultImplStub!.alamofireRequest(location))
        
    }
    

	 struct __StubbingProxy_LocationRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func alamofireRequest<M1: Cuckoo.Matchable>(_ location: M1) -> Cuckoo.ClassStubFunction<(String), Observable<SearchDataModel>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: location) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockLocationRepository.self, method: "alamofireRequest(_: String) -> Observable<SearchDataModel>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_LocationRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func alamofireRequest<M1: Cuckoo.Matchable>(_ location: M1) -> Cuckoo.__DoNotUse<(String), Observable<SearchDataModel>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: location) { $0 }]
	        return cuckoo_manager.verify("alamofireRequest(_: String) -> Observable<SearchDataModel>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class LocationRepositoryStub: LocationRepository {
    

    

    
     override func alamofireRequest(_ location: String) -> Observable<SearchDataModel>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<SearchDataModel>).self)
    }
    
}

