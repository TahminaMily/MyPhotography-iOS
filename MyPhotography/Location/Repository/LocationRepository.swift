//
//  LocationRepository.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// TODO: replace with a struct
typealias LocationDetail = (Location, Location.Note?)

struct LocationRepository: Repository {
    typealias Identifier = String
    typealias Model = LocationDetail
    
    private let remoteRepo = LocationRemoteRepository()
    private let localRepo = LocationLocalRepository()
    private let notesRepo = LocationNoteRepository()
    
    // combines network data, local data and notes objects together
    func getAll() -> Observable<[Model]> {
        let l1 = remoteRepo.getAll()
        let l2 = localRepo.getAll()
        let n1 = notesRepo.getAll()
        let allLocations: Observable<[LocationDetail]> = Observable.combineLatest(l1, l2, n1) { remoteLocations, localLocations, notes in
            let all = remoteLocations + localLocations
            let notesDict = notes.reduce(into: [String: Location.Note]()) { res, note in
                res[note.locationId] = note
            }
            let details = all.reduce(into: [LocationDetail]()) { res, location in
                res.append((location, notesDict[location.id]))
            }
            return details
        }
        return allLocations
    }
    func get(identifier: Identifier) -> Single<Model?>  { Single.error("Not supported") }
    
    func create(_ locationDetail: Model) -> Completable  {
        let locationCompletable = locationDetail.0.isRemote ? Completable.empty() : localRepo.create(locationDetail.0)
        let noteCompletable = locationDetail.1.flatMap { notesRepo.create($0) } ?? Completable.empty()
        
        return Completable.zip([locationCompletable, noteCompletable])
    }
    
    func update(_ locationDetail: Model) -> Completable  {
        let locationCompletable = locationDetail.0.isRemote ? Completable.empty() : localRepo.update(locationDetail.0)
        let noteCompletable = locationDetail.1.flatMap { notesRepo.update($0) } ?? Completable.empty()
        
        return Completable.zip([locationCompletable, noteCompletable])
    }
    
    func delete(_: Model) -> Completable  { Completable.error("Not supported") }
}
