//
//  APIError.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import Foundation

enum APIError: Error {
    /// 接続エラー(オフライン or タイムアウト)
    case connectionError

    /// レスポンスのデコード失敗
    case decodeError

    /// エラーレスポンス
    case errorResponse(errObject: Decodable)

    /// 無効なリクエスト
    case invalidRequest

    /// 無効なレスポンス
    case invalidResponse

    /// その他
    case others(error: Error, statusCode: Int?)
}
