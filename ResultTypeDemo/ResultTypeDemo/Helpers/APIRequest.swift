//
//  APIRequest.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import Foundation

// MARK: - Protocol
protocol APIRequest {

    associatedtype Response: Decodable
    associatedtype ErrorResponse: Decodable

    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var httpHeaderFields: [String: String] { get }

    func decode(data: Data) -> Response?
    func decode(errorResponseData: Data) -> ErrorResponse?

    /// URLRequestを生成する
    func makeURLRequest(needURLEncoding: Bool) -> URLRequest?
}

// MARK: - Default implementation
extension APIRequest {

    var baseURL: URL {
        guard let url = URL(string: "https://api.gnavi.co.jp/") else {
            fatalError("baseURL is nil.")
        }
        return url
    }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/path"
    }

    var parameters: [String: String] {
        return [:]
    }

    var httpHeaderFields: [String: String] {
        return [:]
    }

    func decode(data: Data) -> Response? {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            print("Response decode error:\(error)")
            return nil
        }
    }

    func decode(errorResponseData: Data) -> ErrorResponse? {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(ErrorResponse.self, from: errorResponseData)
        } catch {
            print("ErrorResponse decode error:\(error)")
            return nil
        }
    }

    func makeURLRequest(needURLEncoding: Bool = false) -> URLRequest? {

        let endPoint = baseURL.absoluteString + path

        let urlQueryItems = parameters.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }

        // String to URL
        guard let url = URL(string: endPoint)?.addQueryItems(urlQueryItems) else {
            assertionFailure("Invalid endpoint:\(endPoint)")
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = httpHeaderFields
        urlRequest.timeoutInterval = 30
        return urlRequest

    }
}
