//
//  APIError.swift
//  GitHubRepo-Combine-UIKit
//
//  Created by 小原宙 on 2023/05/26.
//

import Foundation

enum APIError: LocalizedError {
    case customError(message: String)
    case unauthorizedError
    case maintenaceError
    case networkError
    case jsonParseError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .customError(let message):
            return message
        case .unauthorizedError:
            return "ユーザーセッションの有効期限が切れたため、再度ログインしてください。"
        case .maintenaceError:
            return "メンテナンス中です。終了までしばらくお待ちください。"
        case .networkError:
            return "通信エラーが発生しました。電波の良い所で再度お試しください。"
        case .jsonParseError:
            return "申し訳ありません、データが見つかりませんでした。"
        case .unknownError:
            return "不具合が発生しました。お手数ですが時間をおいてもう一度お試しください。"
        }
    }
}
