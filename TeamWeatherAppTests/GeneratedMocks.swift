// MARK: - Mocks generated from file: TeamWeatherApp/Networking/Repository/AlamofireRepository.swift at 2019-09-25 09:47:02 +0000

//
//  AlamofireRepository.swift
//  TeamWeatherApp
//
//  Created by Matej Hetzel on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//
import Cuckoo
@testable import TeamWeatherApp

import Foundation
import RxSwift


 class MockAlamofireRepository: AlamofireRepository, Cuckoo.ClassMock {
    
     typealias MocksType = AlamofireRepository
    
     typealias Stubbing = __StubbingProxy_AlamofireRepository
     typealias Verification = __VerificationProxy_AlamofireRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: AlamofireRepository?

     func enableDefaultImplementation(_ stub: AlamofireRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func alamofireRequest(_ unit: String, _ location: String) -> Observable<MainWeatherClass> {
        
    return cuckoo_manager.call("alamofireRequest(_: String, _: String) -> Observable<MainWeatherClass>",
            parameters: (unit, location),
            escapingParameters: (unit, location),
            superclassCall:
                
                super.alamofireRequest(unit, location)
                ,
            defaultCall: __defaultImplStub!.alamofireRequest(unit, location))
        
    }
    

	 struct __StubbingProxy_AlamofireRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func alamofireRequest<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ unit: M1, _ location: M2) -> Cuckoo.ClassStubFunction<(String, String), Observable<MainWeatherClass>> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: unit) { $0.0 }, wrap(matchable: location) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAlamofireRepository.self, method: "alamofireRequest(_: String, _: String) -> Observable<MainWeatherClass>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_AlamofireRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func alamofireRequest<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ unit: M1, _ location: M2) -> Cuckoo.__DoNotUse<(String, String), Observable<MainWeatherClass>> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: unit) { $0.0 }, wrap(matchable: location) { $0.1 }]
	        return cuckoo_manager.verify("alamofireRequest(_: String, _: String) -> Observable<MainWeatherClass>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class AlamofireRepositoryStub: AlamofireRepository {
    

    

    
     override func alamofireRequest(_ unit: String, _ location: String) -> Observable<MainWeatherClass>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<MainWeatherClass>).self)
    }
    
}

