//
//  LocationWebService.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation
import RxSwift

enum LocationResource {
    static var all: Resource<[Location]> {
        let url = URL(string: "https://gist.githubusercontent.com/TahminaMily/36194bb0dd87d7fa706b164bfc2c834c/raw/5002c2948a619c59a7dc873caefd1c563c605122/locations.json")!
        return Resource<[Location]>(url: url, parse: { data -> [Location] in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(LocationResponse.self, from: data).locations
        })
    }
}

final class LocationWebService: WebService {
    let loader: URLLoader = URLSessionLoader()
    
    func getLocations() -> Observable<[Location]> {
        return load(resource: LocationResource.all)
    }
}
