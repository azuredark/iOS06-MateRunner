//
//  DefaultMateRepository.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/16.
//

import Foundation

import RxSwift

final class DefaultMateRepository: MateRepository {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchMateNickname() -> Observable<[String]> {
        return self.networkService.fetchData(
            type: [String].self,
            collection: "User",
            document: "yujin",
            field: "mate"
        )
    }
    
    func fetchMateProfileImage(from nickname: String) -> Observable<String> {
        return self.networkService.fetchData(
            type: String.self,
            collection: "User",
            document: nickname,
            field: "image"
        )
    }
}
