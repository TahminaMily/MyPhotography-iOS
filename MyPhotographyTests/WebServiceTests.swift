//
//  WebServiceTests.swift
//  MyPhotographyTests
//
//  Created by Tahmina Khanam on 5/11/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import MyPhotography

struct AnyModel: Decodable, Equatable { }

enum AnyError: Error {
    case any
}

class MockURLLoader: URLLoader {
    func load(url: URL) -> Observable<Data> {
        return Observable.just(Data())
    }
}

class MockService: WebService {
    var loader: URLLoader = MockURLLoader()
    func load(resource: Resource<AnyModel>) -> Observable<AnyModel> {
        return Observable.just(AnyModel())
    }
}

class WebServiceTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    var sut: WebService!
    let resource = Resource<AnyModel>(url: URL(fileURLWithPath: "")) { _ in AnyModel() }
    
    override func setUp() {
        super.setUp()
        sut = MockService()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }

    func testLoad() {
        
        let loadObserver = scheduler.createObserver(AnyModel.self)
        sut.load(resource: resource)
            .bind(to: loadObserver)
            .disposed(by: disposeBag)

        XCTAssertEqual(loadObserver.events, [.next(0, AnyModel()), .completed(0)])
    }

}
