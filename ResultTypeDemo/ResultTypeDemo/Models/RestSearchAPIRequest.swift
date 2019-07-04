//
//  RestSearchAPIRequest.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import Foundation

final class RestSearchAPIRequest: APIRequest {

    typealias Response = RestSearchAPIResponse
    typealias ErrorResponse = RestSearchAPIErrorResponse
    var path: String = "RestSearchAPI/v3/"
    var parameters: [String: String]

    init(parameters: [String: String]) {
        self.parameters = parameters
    }
}
