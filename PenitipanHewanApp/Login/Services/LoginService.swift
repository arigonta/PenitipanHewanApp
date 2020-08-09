//
//  File.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 10/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
struct LoginService {
    
    let resourceURL: URL
    let username: String
    let password: String
    
    init(endpoint: String, username: String, password: String) {
        let stringURL = CommonHelper.shared.BASE_URL + endpoint
        guard let resourceURL = URL(string: stringURL) else {fatalError()}
        self.resourceURL = resourceURL
        self.username = username
        self.password = password
    }

    func sendRequest(completion: @escaping(Result<loginAPIModel, Error>) -> Void) {
        let urlComponent = URLComponents(string: resourceURL.absoluteString)
        let url = urlComponent?.url?.absoluteString ?? ""
        
        let param = ["username": username, "password": password]

        NetworkHelper.shared.connect(url: url, params: param, model: loginAPIModel.self) { (result) in
            completion(result)
        }
    }
}
