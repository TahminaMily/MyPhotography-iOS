//
//  WebService.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation
import RxSwift

struct Resource<Model: Decodable> {
    let url: URL
    let parse: (Data) throws -> Model
}

enum WebServiceError: Error {
    case parsing(underlying: Error)
    case unknown
}

protocol URLLoader {
    func load(url: URL) -> Observable<Data>
}

protocol WebService {
    var loader: URLLoader { get }
    func load<Model>(resource: Resource<Model>) -> Observable<Model>
}

extension WebService {
    func load<Model>(resource: Resource<Model>) -> Observable<Model> {
        return loader.load(url: resource.url).map { try resource.parse($0) }
    }
}
