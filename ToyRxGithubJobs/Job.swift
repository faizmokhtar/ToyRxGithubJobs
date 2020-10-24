//
//  Job.swift
//  ToyRxGithubJobs
//
//  Created by AD0502 on 24/10/2020.
//

import Foundation

struct Job: Decodable {
    let id: String
    let type: String
    let url: URL
    let title: String
    let company: String
}
