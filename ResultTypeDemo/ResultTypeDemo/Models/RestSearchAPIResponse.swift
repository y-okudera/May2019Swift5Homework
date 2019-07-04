//
//  RestSearchAPIResponse.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import Foundation

/// レストラン検索結果
struct RestSearchAPIResponse: Codable {
    var totalHitCount = 0
    var rest: [Restaurant] = []
}

struct Restaurant: Codable {
    var access = Access()
    var address = ""
    var budget = 0
    var imageUrl = ImageUrl()
    var name = ""
    var tel = ""
}

struct ImageUrl: Codable {
    var shopImage1 = ""
}

struct Access: Codable {
    var station = ""
    var walk = ""
}
