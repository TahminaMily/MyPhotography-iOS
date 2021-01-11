//
//  LocationResponse.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation

struct LocationResponse: Decodable {
    let locations: [Location]
    let updated: Date
}
