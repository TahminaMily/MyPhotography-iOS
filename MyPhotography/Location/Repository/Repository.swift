//
//  Repository.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 5/11/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol Repository {
    associatedtype Model
    associatedtype Identifier: Hashable
    func getAll() -> Observable<[Model]>
    func get(identifier: Identifier) -> Single<Model?>
    func create(_: Model) -> Completable
    func update(_: Model) -> Completable
    func delete(_: Model) -> Completable
}
