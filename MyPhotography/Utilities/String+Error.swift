//
//  String+Error.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 5/11/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import Foundation

extension String: Error {}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
