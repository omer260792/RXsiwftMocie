//
//  URLRequest+Extensions.swift
//  MovieListRXSwift
//
//  Created by Omer Cohen on 4/28/19.
//  Copyright © 2019 Omer Cohen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Codable> {
    let url: URL
}

extension URLRequest {
    
    static func load<T>(resource: Resource<T>) -> Observable<[MovieObject]> {
        
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> [MovieObject] in
                return try! JSONDecoder().decode([MovieObject].self, from: data)
            }.asObservable()
        
    }
    
}

