//
//  HomeUseCase.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import CoreLocation
import Foundation

import RxSwift

enum LocationAuthorizationStatus {
    case allowed, disallowed, notDetermined
}

final class HomeUseCase {
    private let locationService: LocationService
    var authorizationStatus = BehaviorSubject<LocationAuthorizationStatus?>(value: nil)
    var disposeBag = DisposeBag()
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func checkAuthorization() {
        self.locationService.requestAuthorization()
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    self?.authorizationStatus.onNext(.allowed)
                case .notDetermined:
                    self?.authorizationStatus.onNext(.notDetermined)
                case .denied, .restricted:
                    self?.authorizationStatus.onNext(.disallowed)
                @unknown default:
                    self?.authorizationStatus.onNext(nil)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchUserLocation() -> Observable<CLLocation> {
        self.locationService.start()
        return self.locationService.observeUpdatedLocation()
            .compactMap({ $0.last })
            .asObservable()
    }
}
