//
//  LocationListCell.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LocationListCell: UITableViewCell, Reusable {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    func prepare(with viewModel: LocationListItemViewModel) {
        titleLabel.text = viewModel.title
        locationLabel.text = viewModel.subtitle
    }
}
