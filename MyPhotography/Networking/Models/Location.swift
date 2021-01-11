//
//  Location.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    var name: String
    let latitude: Double
    let longitude: Double
    var isRemote: Bool
}
extension Location: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lng"
        case isRemote
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.isRemote = try container.decodeIfPresent(Bool.self, forKey: .isRemote) ?? true
    }
}

extension Location {
    //poor man's unique id
    var id: String { return "\(latitude):\(longitude)" }
}

extension Location: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Location {
    struct Note: Codable {
        let locationId: String
        let text: String?
    }
}

extension Location {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
