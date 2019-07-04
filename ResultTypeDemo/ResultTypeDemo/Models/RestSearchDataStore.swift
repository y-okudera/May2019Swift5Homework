//
//  RestSearchDataStore.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import Foundation

/// レストラン検索結果を通知するプロトコル
protocol RestSearchResult: class {
    func fetchSucceeded(restaurants: [Restaurant])
    func fetchFailed(errorMessage: String)
}

/// レストラン検索APIリクエストクラス
final class RestSearchDataStore {

    private let perPage = 20
    private var areaCode: String
    private var requestCount = 0
    private var totalCount = 1

    weak var delegate: RestSearchResult?
    var isLoading = false

    init(areaCode: String) {
        self.areaCode = areaCode
    }

    /// リクエストパラメータを生成する
    private func createParameters() -> [String: String] {
        return [
            "keyid": "",
            "areacode_l": areaCode,
            "hit_per_page": perPage.description,
            "offset_page": currentRequestCount().description
        ]
    }

    private func apiErrorToMessage(_ apiError: APIError) -> String {
        switch apiError {
        case .connectionError:
            return "通信エラー"
        case .decodeError:
            return "デコード失敗"
        case .errorResponse(let errObject):
            guard let apiErrorResponse = errObject as? RestSearchAPIErrorResponse else {
                return "不正なレスポンス"
            }

            if apiErrorResponse.error.isEmpty {
                return "エラーメッセージ無し"
            }
            var allMessages = ""
            for error in apiErrorResponse.error {
                if allMessages.isEmpty {
                    allMessages += error.description()
                } else {
                    allMessages += "\n"
                    allMessages += error.description()
                }
            }
            return allMessages
        case .invalidRequest:
            return "不正なリクエスト"
        case .invalidResponse:
            return "不正なレスポンス"
        case .others(let error, let statusCode):
            print("error:\(error)")
            print("statusCode:\(String(describing: statusCode))")
            return "その他のエラー"
        }
    }

    func requestAPI() {

        if isLoading {
            return
        }

        isLoading = true
        incrementRequestCount()
        print("offsetPage: \(currentRequestCount())")

        let restSearchAPIRequest = RestSearchAPIRequest(parameters: createParameters())
        APIClient.request(request: restSearchAPIRequest) { [weak self] result in

            guard let weakSelf = self else {
                return
            }

            switch result {
            case .success(let response):
                print("response:\(response)")
                guard let searchResponse = response as? RestSearchAPIResponse else {
                    assertionFailure("Invalid response")
                    weakSelf.delegate?.fetchFailed(errorMessage: weakSelf.apiErrorToMessage(.invalidResponse))
                    weakSelf.isLoading = false
                    weakSelf.decrementRequestCount()
                    return
                }
                // トータルカウントを更新
                weakSelf.updateTotal(searchResponse.totalHitCount)
                weakSelf.isLoading = false
                DispatchQueue.main.async {
                    weakSelf.delegate?.fetchSucceeded(restaurants: searchResponse.rest)
                }

            case .failure(let apiError):
                print("apiError:\(apiError)")
                weakSelf.decrementRequestCount()
                weakSelf.isLoading = false
                DispatchQueue.main.async {
                    weakSelf.delegate?.fetchFailed(errorMessage: weakSelf.apiErrorToMessage(apiError))
                }
            }
        }
    }
}

// MARK: - Count of API requests.
extension RestSearchDataStore {

    private func currentRequestCount() -> Int {
        return requestCount
    }

    private func incrementRequestCount() {
        requestCount += 1
    }

    private func decrementRequestCount() {
        requestCount -= 1
    }

    private func updateTotal(_ total: Int) {
        totalCount = total
    }

    func total() -> Int {
        return totalCount
    }

    func hasMoreRequest() -> Bool {
        return totalCount > requestCount * perPage
    }
}
