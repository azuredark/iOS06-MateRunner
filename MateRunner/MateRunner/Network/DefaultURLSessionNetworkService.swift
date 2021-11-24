//
//  DefaultURLSessionNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/20.
//

import Foundation

import RxSwift

enum URLSessionNetworkServiceError: Error {
    case error
}

final class DefaultURLSessionNetworkService: URLSessionNetworkService {
    func post<T: Codable>(_ data: T, url urlString: String, headers: [String: String]? = nil) -> Observable<Void> {
        return Observable<Void>.create { observer in
            guard let url = URL(string: urlString),
                  let json = try? JSONEncoder().encode(data) else {
                      observer.onError(URLSessionNetworkServiceError.error)
                      observer.onCompleted()
                      return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = json
            
            headers?.forEach({ header in
                request.addValue(header.value, forHTTPHeaderField: header.key)
            })

            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(())
                }
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func get(url urlString: String) -> Observable<Data> {
        return Observable<Data>.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(URLSessionNetworkServiceError.error)
                observer.onCompleted()
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
    
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    guard let data = data else { return }
                    observer.onNext(data)
                }
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
