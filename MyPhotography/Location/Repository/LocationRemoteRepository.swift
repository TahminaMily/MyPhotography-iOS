//
//  LocationRemoteRepository.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 5/11/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct LocationRemoteRepository: Repository {
    typealias Model = Location
    
    func getAll() -> Observable<[Model]> {
        return LocationWebService().getLocations()
    }
    
    func get(identifier: Int) -> Single<Model?> { Single.error("Not supported") }
    func create(_: Model) -> Completable { Completable.error("Not supported") }
    func update(_: Model) -> Completable { Completable.error("Not supported") }
    func delete(_: Model) -> Completable { Completable.error("Not supported") }
}
