//
//  URLSessionLoader.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2021 Tahmina Khanam. All rights reserved.
//

import Foundation
import RxSwift

// simple implementation using `URLSession`. this can be easily replaced with other networking libraries like `Alamofire` or `Moya`
final class URLSessionLoader: URLLoader {
    func load(url: URL) -> Observable<Data> {
        return URLSession.shared.rx.data(request: URLRequest(url: url))
    }
}
