//
//  LocationModelTests.swift
//  LocationModelTests
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import XCTest
@testable import MyPhotography

class LocationModelTests: XCTestCase {

    var sut: Location!
    
    override func setUp() {
        
        let locationData = Data("""
            {
                "name": "Milsons Point",
                "lat": -33.850750,
                "lng": 151.212519
            }
            """.utf8)
        
        sut = try! JSONDecoder().decode(Location.self, from: locationData)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testLocationDecode() throws {
        XCTAssertEqual(sut.name, "Milsons Point", "should have correct location name")
        XCTAssertEqual(sut.latitude, -33.850750, "should have correct location latitude")
        XCTAssertEqual(sut.longitude, 151.212519, "should have correct location longitude")
    }
    
    func testEmptyIsRemoteExpectDecodeToTrue() {
        XCTAssertTrue(sut.isRemote)
    }

}
