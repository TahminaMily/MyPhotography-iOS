//
//  LocationListViewModel.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 31/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct LocationListItemViewModel {
    let title: String
    let subtitle: String 
    init(_ location: Location) {
        title = (location.isRemote ? "📍" : "📌") + " " + location.name
        subtitle = "Latitude: \(location.latitude) Longitude: \(location.longitude)"
    }
}

class LocationListViewModel {
    
    private let repository: LocationRepository
    
    let items: Observable<[LocationDetail]>
    
    init(repository: LocationRepository) {
        self.repository = repository
        
        items = repository.getAll().asObservable()
    }
}
