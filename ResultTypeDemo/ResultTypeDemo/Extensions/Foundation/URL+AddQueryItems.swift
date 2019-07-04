//
//  URL+AddQueryItems.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import Foundation

extension URL {
    // Return a new URL with multiple queries added.
    func addQueryItems(_ queryItems: [URLQueryItem]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: nil != baseURL) else {
            return nil
        }
        components.queryItems = queryItems + (components.queryItems ?? [])
        return components.url
    }
}
