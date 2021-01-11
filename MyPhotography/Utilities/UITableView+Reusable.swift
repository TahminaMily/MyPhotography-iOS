//
//  UITableView+Reusable.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import UIKit

extension UITableView {

    func dequeueReusableCell<T: Reusable & UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with identifier \(cellType.reuseIdentifier)")
        }
        return cell
    }
}
