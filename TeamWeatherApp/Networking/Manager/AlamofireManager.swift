//
//  AlamofireManager.swift
//  TeamWeatherApp
//
//  Created by Matej Hetzel on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class AlamofireManager {
    
    func requestData(url: String) -> Observable<MainWeatherModel> {
          let requestUrl = URL(string: url)!
          
          return Observable.create{   observable -> Disposable in
          
              Alamofire.request(requestUrl)
                      .responseJSON   { response in
                  do {
                      guard let data = response.data else {return}
                      let article = try JSONDecoder().decode(MainWeatherModel.self, from: data)
                      observable.onNext(article)
                  }   catch let jsonErr {
                      observable.onError(jsonErr)
                  }
              }
              return Disposables.create()
          
          }
      }
}
