//
//  APIClient.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import Foundation

struct APIClient {

    /// API Request
    static func request<T: APIRequest>(request: T, completionHandler: @escaping (Result<Decodable, APIError>) -> Void) {

        guard let urlRequest = request.makeURLRequest(needURLEncoding: true) else {
            completionHandler(.failure(.invalidRequest))
            return
        }
        print("urlRequest: \(urlRequest)")

        let reachable = isReachable(url: urlRequest.url)
        if !reachable {
            completionHandler(.failure(.connectionError))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in

            // エラーチェック
            if let error = error {
                let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode
                let apiError = errorToAPIError(error: error, statusCode: statusCode)
                completionHandler(.failure(apiError))
                return
            }

            // レスポンスデータのnilチェック
            guard let responseData = data else {
                completionHandler(.failure(.invalidResponse))
                return
            }

            let result = self.decode(responseData: responseData, request: request)
            completionHandler(result)
            }.resume()
    }
}

extension APIClient {

    /// ネットワーク状態をチェックする
    ///
    /// - Parameters:
    ///   - url: 接続先のURL
    /// - Returns: true: ホストに接続成功, false: ホストに接続失敗
    private static func isReachable(url: URL?) -> Bool {
        guard let urlString = url?.absoluteString, let components = URLComponents(string: urlString) else {
            return false
        }
        return NetworkReachability.checkReachability(hostName: components.host)
    }

    /// ErrorをAPIErrorに変換する
    private static func errorToAPIError(error: Error, statusCode: Int?) -> APIError {
        print("HTTP status code:\(String(describing: statusCode))")
        if let error = error as? URLError {
            if error.code == .timedOut {
                print("timed out.")
                return .connectionError
            }
            if error.code == .notConnectedToInternet {
                print("Not connected to internet.")
                return .connectionError
            }
        }
        print("dataResponse.result.error:\(error)")
        return .others(error: error, statusCode: statusCode)
    }

    /// デコード
    private static func decode<T: APIRequest>(responseData: Data, request: T) -> Result<Decodable, APIError> {
        if let object = request.decode(data: responseData) {
            print("response:\(object)")
            return .success(object)
        }

        if let apiErrorObject = request.decode(errorResponseData: responseData) {
            print("apiErrorObject:\(apiErrorObject)")
            return .failure(.errorResponse(errObject: apiErrorObject))
        }

        print("Decoding failure.")
        return .failure(.decodeError)
    }
}
