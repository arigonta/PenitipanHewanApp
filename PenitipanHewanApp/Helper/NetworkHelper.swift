//
//  NetworkHelper.swift
//  FilmKu
//
//  Created by Ari Gonta on 16/05/20.
//  Copyright © 2020 Ari Gonta. All rights reserved.
//

import UIKit

enum HTTPMethods:String {
    case POST, GET, DELETE, OPTIONS, PUT, PATCH
}

class NetworkHelper: NSObject {
    static let shared: NetworkHelper = {
        return NetworkHelper()
    }()
    
    let task = URLSession.shared
    var timeoutInterval: TimeInterval = 60
    var HTTPMethod: HTTPMethods?
    
    private func resetValueToDefault() {
        timeoutInterval = 60
        HTTPMethod = nil
    }
    
    func connect<T:Decodable>( url: String, params: [String:Any]?, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let _url = URL(string: url) else {
            fatalError("invalid url: " + url)
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = params == nil ? "GET" : "POST"
        request.timeoutInterval = 60
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let httpMethodString = self.HTTPMethod {
            request.httpMethod = httpMethodString.rawValue
        }
        
        if let param = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options:[])
            } catch let e {
//                print(e.localizedDescription)
                completion(.failure(e))
            }
        }
        
        self.task.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let responses = response as? HTTPURLResponse {
                    if responses.statusCode < 200 || responses.statusCode >= 300 {
                        let errorCode = NSError(domain: "Status Code", code: responses.statusCode, userInfo: nil)
                        completion(.failure(errorCode))
//                        return
                    }
                }
                if let datas = data, let stringResponse = String(data: datas, encoding: .utf8) {
                    print(stringResponse)
                    
                    do {
                        let responseModel = try JSONDecoder().decode(T.self, from: datas)
                        completion(.success(responseModel))
                    } catch let jsonError {
                        completion(.failure(jsonError))
                    }
                }
            }
        }.resume()
        resetValueToDefault()
    }
}

//MARK: Create Call Service Every Product

//import UIKit
//struct MovieAPIManager {
//    let resourceURL: URL
//    let genreID: Int
//    let page: Int?
//    init(endpoint: String, genresID: Int, page: Int) {
//        let stringURL = Constants.URL + endpoint
//        guard let resourceURL = URL(string: stringURL) else {fatalError()}
//        self.resourceURL = resourceURL
//        self.genreID = genresID
//        self.page = page
//    }
//
//    func sendRequest(completion: @escaping(Result<MovieResponse, Error>) -> Void) {
//        var queryEndPoints: [URLQueryItem] = []
//        queryEndPoints.append(URLQueryItem(name: "api_key", value: Constants.API_KEY))
//        queryEndPoints.append(URLQueryItem(name: "page", value: "\(page ?? 1)"))
//        queryEndPoints.append(URLQueryItem(name: "with_genres", value: "\(genreID)"))
//
//        var urlComponent = URLComponents(string: resourceURL.absoluteString)
//        urlComponent?.queryItems = queryEndPoints
//        let url = urlComponent?.url?.absoluteString ?? ""
//
//        NetworkHelper.shared.connect(url: url, params: nil, model: MovieResponse.self) { (result) in
//            completion(result)
//        }
//    }
//}

//MARK: Use In View Controller

//let genreRequest = MovieAPIManager(endpoint: Constants.endpoint_discover, genresID: genreID, page: pages)
//genreRequest.sendRequest(completion: { [weak self] result in
//    switch result {
//    case .failure(_ ):
//        self?.alertLostConnection()
//        break
//    case .success(let value):
//        self?.isLoadingList = false
//        self?.movieResponse = value
//        self?.movie.append(contentsOf: value.results)
//        self?.movieTableView.reloadData()
//    }
//})
