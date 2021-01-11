//
//  LocationLocalRepository.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 5/11/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct LocationLocalRepository: Repository {
    typealias Model = Location
    private enum Constants {
        static let key = "locations"
    }
    func getAll() -> Observable<[Model]> {
        return UserDefaults.standard.rx
            .observe(Data.self, Constants.key)
            .map { data -> [Model] in
                return data.flatMap { try? JSONDecoder().decode([Model].self, from: $0) } ?? []
            }
    }
    
    func get(identifier: Int) -> Single<Model?> { Single.error("Not supported") }
    
    func create(_ location: Model) -> Completable {
        return upsert(location)
    }
    
    func update(_ location: Location) -> Completable {
        return upsert(location)
    }
    
    //for our data structure upsert is easier
    private func upsert(_ location: Location) -> Completable {
        return getAll()
        .map {
            var locations = $0
            if let index = locations.firstIndex(of: location) {
                locations[index] = location
            } else {
                locations.append(location)
            }
            return locations
        }
        .do(onNext: { try? self.saveAll(models: $0) })
        .ignoreElements()
    }
    
    func delete(_: Location) -> Completable {
        Completable.error("Not supported")
    }
    
    private func saveAll(models: [Model]) throws {
        let locationData = try JSONEncoder().encode(models)
        UserDefaults.standard.set(locationData, forKey: Constants.key)
    }
}
