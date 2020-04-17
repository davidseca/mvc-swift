//
//  NetworkManager.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import Alamofire

/// Content Type can be easyly scalable
public enum Content: String {
    case transactions
}

public class NetworkManager: NetworkManagerProtocol {

    static let sharedInstance = NetworkManager()

    private static let defaultTimeout: TimeInterval = 10

    private init() { }

    public func getContent(content: Content, completion: @escaping ((Data?, Bool) -> ())) {
        switch content {
        case .transactions: self.getTransactionsData(completion: completion)
        }
    }

    private func getTransactionsData(completion: @escaping ((Data?, Bool) -> ())) {
        let data = self.getJsonFromFile("Transactions")
        completion(data, false)
    }

    private func getJsonFromFile(_ resource: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: resource, withExtension: "json") else {
            return nil
        }
        var json = Data()
        do {
            json = try Data(contentsOf: url)
        } catch {

        }
        print(json)

        return json
    }

    private func urlRequest(for url: String, _ parameters: [String: String]? = nil, timeout: TimeInterval? = NetworkManager.defaultTimeout) -> URLRequest? {
        guard let str = self.urlString(url, parameters), let url = URL(string: str) else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        if let timeout = timeout {
            urlRequest.timeoutInterval = timeout
        }

        return urlRequest
    }

    private func urlString(_ url: String, _ parameters: [String: String]?) -> String? {
        let queryItems = parameters?.map { (k, v) in
            URLQueryItem(name: k, value: v)
        }

        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = queryItems
        } else {
            urlComponents.queryItems?.append(contentsOf: queryItems ?? [])
        }

        return urlComponents.url?.absoluteString
    }

    private func isOffline(_ error: Error) -> Bool {
        if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
            return true
        }
        return false
    }

    public func getData(_ url: String, headerParameters: [String: String]? = nil, parameters: [String: String]? = nil, timeout: TimeInterval? = nil, completion: @escaping ((Data?, Bool, Int?) -> ())) {

        guard var request = self.urlRequest(for: url, parameters, timeout: timeout) else {
            return completion(nil, false, nil)
        }

        headerParameters?.forEach { header, value in
            request.addValue(value, forHTTPHeaderField: header)
        }

        Alamofire
            .request(request)
            .validate()
            .responseJSON { response in
                let url = request.url?.absoluteString ?? ""
                let statusCode = response.response?.statusCode
                switch response.result {
                case .success:
                    completion(response.data, false, statusCode)
                case .failure(let error):
                    print("error from \(url)")
                    print(error)
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print(str)
                    }
                    completion(nil, self.isOffline(error), statusCode)
                }
        }
    }
}

public protocol NetworkManagerProtocol {

    func getContent(content: Content, completion: @escaping ((Data?, Bool) -> ()))

}
