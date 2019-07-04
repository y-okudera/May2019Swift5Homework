//
//  RestSearchAPIErrorResponse.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import Foundation

/// レストラン検索結果エラーレスポンス
struct RestSearchAPIErrorResponse: Codable {
    var error: [RestSearchAPIError] = []
}

struct RestSearchAPIError: Codable {
    var code = 0
    var message = ""

    func description() -> String {
        return "[\(code)] \(message)"
    }
}
