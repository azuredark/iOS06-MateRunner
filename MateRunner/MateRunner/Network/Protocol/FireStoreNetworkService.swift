//
//  FireStoreNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/07.
//

import Foundation

import RxSwift

protocol FireStoreNetworkService {
    func fetchData<T>(
        type: T.Type,
        collection: String,
        document: String,
        field: String
    ) -> Observable<T>
    
    func writeDTO<T: Codable>(
        _ dto: T,
        collection: String,
        document: String,
        key: String
    ) -> Observable<Void>
    
    func fetchProfile(
        collection: String,
        document: String
    ) -> Observable<UserProfile>
    
    func documentDoesExist(collection: String, document: String) -> Observable<Bool>
    func writeData(collection: String, document: String, data: [String: Any]) -> Observable<Bool>
    func fetchFilteredDocument(collection: String, with text: String) -> Observable<[String]>
}
