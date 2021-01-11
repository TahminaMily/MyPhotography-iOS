//
//  LocationDetailViewController.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 2/11/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LocationDetailViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var noteTextView: UITextView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: LocationDetailViewModel!
    
    static func create(locationDetail: LocationDetail) -> LocationDetailViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LocationDetailViewController") as? LocationDetailViewController else { return nil }
        vc.viewModel = LocationDetailViewModel(locationDetail: locationDetail, repository: LocationRepository())
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initial value
        nameTextField.text = viewModel.locationDetail.0.name
        latitudeTextField.text = viewModel.locationDetail.0.latitude.description
        longitudeTextField.text = viewModel.locationDetail.0.longitude.description
        noteTextView.text = viewModel.locationDetail.1?.text
        nameTextField.isEnabled = viewModel.allowEditingName
        
        let saveButton = UIBarButtonItem()
        saveButton.title = "Save"
        navigationItem.rightBarButtonItem = saveButton
        
        //bind input to viewmodel
        nameTextField.rx.value.bind(to: viewModel.name).disposed(by: disposeBag)
        // lat-long textfields are not stricly needed, kept it for consistancy
        latitudeTextField.rx.value.bind(to: viewModel.latitude).disposed(by: disposeBag)
        longitudeTextField.rx.value.bind(to: viewModel.longitude).disposed(by: disposeBag)
        noteTextView.rx.value.bind(to: viewModel.note).disposed(by: disposeBag)
        saveButton.rx.tap.bind(to: viewModel.didTapSave).disposed(by: disposeBag)
        
        //bind ui from viewmodel output
        viewModel.allowSave.drive(saveButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.didSave.subscribe().disposed(by: disposeBag)
    }
}

class LocationDetailViewModel {
    //dependencies
    let locationDetail: LocationDetail
    let repository: LocationRepository
    
    //input
    let name: AnyObserver<String?>
    let latitude: AnyObserver<String?>
    let longitude: AnyObserver<String?>
    let note: AnyObserver<String?>
    let didTapSave: AnyObserver<Void>
    
    //output
    let allowSave: Driver<Bool>
    let didSave: Completable
    var allowEditingName: Bool {
        //allow editing name only if its local
        return locationDetail.0.isRemote == false
    }

    init(locationDetail: LocationDetail,
         repository: LocationRepository) {
        self.locationDetail = locationDetail
        self.repository = repository
        
        let name = BehaviorSubject<String?>(value: locationDetail.0.name)
        self.name = AnyObserver(name)
        let latitude = BehaviorSubject<String?>(value: locationDetail.0.latitude.description)
        self.latitude = AnyObserver(latitude)
        let longitude = BehaviorSubject<String?>(value: locationDetail.0.longitude.description)
        self.longitude = AnyObserver(longitude)
        let note = BehaviorSubject<String?>(value: locationDetail.1?.text)
        self.note = AnyObserver(note)
        
        let didTapSave = PublishSubject<Void>()
        self.didTapSave = AnyObserver(didTapSave)
        
        let input = Observable.combineLatest(name, latitude, longitude, note)
            .map { (name, lat, long, note) -> (String, Double, Double, String)? in
                guard let lat = lat.flatMap({ Double($0) }), let long = long.flatMap({ Double($0) }), name?.isEmpty == false else { return nil }
                return (name ?? "", lat, long, note ?? "")
            }
        
        allowSave = input.map { $0 == nil ? false : true }.asDriver(onErrorJustReturn: false)
        
        didSave = didTapSave
            .withLatestFrom(input)
            .compactMap { $0 }
            .map { values -> LocationDetail in
                let location = locationDetail.0.isRemote ? locationDetail.0 : Location(name: values.0, latitude: values.1, longitude: values.2, isRemote: locationDetail.0.isRemote)
                let note: Location.Note? = values.3.isEmpty ? nil : Location.Note(locationId: location.id, text: values.3)
                return (location, note)
            }
            .flatMap { locationDetail in
                return repository.update(locationDetail)
            }
            .asCompletable()
    }
}
