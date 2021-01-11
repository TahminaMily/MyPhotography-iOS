//
//  LocationNoteRepository.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 5/11/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LocationNoteRepository: Repository {
    
    typealias Model = Location.Note
    private enum Constants {
        static let key = "location-notes"
    }
    
    private var notes: Observable<[String: Model]> {
        return UserDefaults.standard.rx
            .observe(Data.self, Constants.key)
            .map { data -> [String: Model] in
                return data.flatMap{ try? JSONDecoder().decode([String: Model].self, from: $0) } ?? [:]
            }
    }
    
    func getAll() -> Observable<[Model]> {
        return notes
            .map { Array($0.values) }
    }
    
    func get(identifier: String) -> Single<Model?> {
        return notes.map { dict in dict[identifier] }.asSingle()
    }
    
    func create(_ note: Model) -> Completable {
        return upsert(note)
    }
    
    func update(_ note: Model) -> Completable {
        return upsert(note)
    }
    
    //for our data structure upsert is easier
    private func upsert(_ note: Model) -> Completable {
        return notes.map { dict in
            var notes = dict
            notes[note.locationId] = note
            return notes
        }
        .do(onNext: {
            try? self.saveAll(models: $0)
        })
        .ignoreElements()
    }
    
    func delete(_ note: Model) -> Completable {
        return notes.map { dict in
            var notes = dict
            notes[note.locationId] = nil
            return notes
        }
        .do(onNext: {
            try? self.saveAll(models: $0)
        })
        .ignoreElements()
    }
    
    private func saveAll(models: [String: Model]) throws {
        let noteData = try JSONEncoder().encode(models)
        UserDefaults.standard.set(noteData, forKey: Constants.key)
    }
}
