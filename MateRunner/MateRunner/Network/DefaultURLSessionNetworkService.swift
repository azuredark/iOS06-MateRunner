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
    private enum HTTPMethod {
        static let get = "GET"
        static let post = "POST"
        static let patch = "PATCH"
        static let delete = "DELETE"
    }
    
    func post<T: Codable>(_ data: T, url urlString: String, headers: [String: String]? = nil) -> Observable<Void> {
        return self.requestWithBody(data, url: urlString, headers: headers, method: HTTPMethod.post)
    }
    
    func patch<T: Codable>(_ data: T, url urlString: String, headers: [String: String]? = nil) -> Observable<Void> {
        return self.requestWithBody(data, url: urlString, headers: headers, method: HTTPMethod.patch)
    }
    
    func delete(url urlString: String, headers: [String: String]? = nil) -> Observable<Void> {
        return Observable<Void>.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(URLSessionNetworkServiceError.error)
                observer.onCompleted()
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get
            
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
    
    private func requestWithBody<T: Codable>(
        _ data: T, url urlString: String,
        headers: [String: String]? = nil,
        method: String
    ) -> Observable<Void> {
        return Observable<Void>.create { observer in
            guard let url = URL(string: urlString),
                  let json = try? JSONEncoder().encode(data) else {
                      observer.onError(URLSessionNetworkServiceError.error)
                      observer.onCompleted()
                      return Disposables.create()
                  }
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.httpBody = json
            
            headers?.forEach({ header in
                request.addValue(header.value, forHTTPHeaderField: header.key)
            })
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                    print(response.description)
                }
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
    
    func get(url urlString: String, headers: [String: String]? = nil) -> Observable<Data> {
        return Observable<Data>.create { observer in
            guard let url = URL(string: urlString) else {
                      observer.onError(URLSessionNetworkServiceError.error)
                      observer.onCompleted()
                      return Disposables.create()
                  }
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get
            
            headers?.forEach({ header in
                request.addValue(header.value, forHTTPHeaderField: header.key)
            })
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    observer.onError(error)
                }
                if let data = data {
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
