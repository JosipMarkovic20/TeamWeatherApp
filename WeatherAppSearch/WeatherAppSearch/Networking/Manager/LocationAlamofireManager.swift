//
//  LocationAlamofireManager.swift
//  WeatherAppSearch
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
class LocationAlamofireManager {
    func requestLocation(url: String) -> Observable<SearchDataModel> {
    
      return Observable.create{   observable -> Disposable in
          let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
          let requestUrl = URL(string: escapedString)!
          
          Alamofire.request(requestUrl)
              .responseJSON   { response in
                  do {
                      guard let data = response.data else {return}
                      let location = try JSONDecoder().decode(SearchDataModel.self, from: data)
                      observable.onNext(location)
                  }   catch let jsonErr {
                      observable.onError(jsonErr)
                  }
          }
          return Disposables.create()
          
      }
    }

}
