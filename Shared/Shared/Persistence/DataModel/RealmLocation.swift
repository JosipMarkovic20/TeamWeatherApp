//
//  RealmLocation.swift
//  Shared
//
//  Created by Josip Marković on 26/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RealmSwift

class RealmLocation: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var lng: String = ""
    @objc dynamic var lat: String = ""
    @objc dynamic var geonameId: Int = 0
    
    func createRealmLocation(location: LocationsClass){
        self.name = location.name
        self.lng = location.lng
        self.lat = location.lat
        self.geonameId = location.geonameId
    }
    
    override class func primaryKey() -> String?{
        return "geonameId"
    }
}
