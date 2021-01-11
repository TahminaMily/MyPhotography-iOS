//
//  ViewController.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 30/10/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LocationListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Location List"
        
        let viewModel = LocationListViewModel(repository: LocationRepository())
        
        let locations = viewModel.items
                        .asDriver(onErrorRecover: { [weak self] error -> Driver<[LocationDetail]> in
                            self?.show(error)
                            return .empty()
                        })
            
        locations
            .drive(tableView.rx.items) { (tableView, row, locationDetail) in
                let cell = tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0), cellType: LocationListCell.self)
                cell.prepare(with: LocationListItemViewModel(locationDetail.0))
                return cell
            }
            .disposed(by: disposeBag)
        
        locations
            .map { _ in return false }.startWith(true)
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(LocationDetail.self)
            .subscribe(onNext: { [unowned self] locationDetail in
                self.goToDetailPage(for: locationDetail)
            })
            .disposed(by: disposeBag)
        tableView.tableFooterView = UIView()
    }
    
    func goToDetailPage(for locationDetail: LocationDetail) {
        guard let vc = LocationDetailViewController.create(locationDetail: locationDetail) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
