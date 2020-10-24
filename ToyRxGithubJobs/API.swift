//
//  API.swift
//  ToyRxGithubJobs
//
//  Created by AD0502 on 24/10/2020.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class API {
    static let shared = API()
    
    private let session = Session.default
    
    func getJobs(for language: String) -> Observable<[Job]> {
        let urlString = "https://jobs.github.com/positions.json?search=\(language)"
        
        return session.rx.request(.get, urlString)
            .debug()
            .responseData()
            .map { _, data in
                let decoder = JSONDecoder()
                return try decoder.decode([Job].self, from: data)
            }
    }
}
