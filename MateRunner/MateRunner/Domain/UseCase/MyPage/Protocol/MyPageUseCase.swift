//
//  MyPageUseCase.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/23.
//

import Foundation

import RxSwift

protocol MyPageUseCase {
    var isNotificationOn: PublishSubject<Bool> { get set }
    func checkNotificationState()
    func updateNotificationState(isOn: Bool)
}
