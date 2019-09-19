//
//  ServerManager.swift
//  Co-browsing
//
//  Created by Артем Бурдейный on 19/09/2019.
//  Copyright © 2019 Артем Бурдейный. All rights reserved.
//

import Foundation

class ServerManager {
    static let shared = ServerManager()
    
    private var baseURL: String {
        return "http://\(Constants.serverPath)"
    }

    enum RequestType: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum RequestURL: String {
        case createSession = "/createSession"
        case deleteSession = "/session?id="
        case getSessions = "/sessions"
    }
    
    func request(to urlPath: RequestURL, appendingPath: String = "", parameters: [String : Any]? = nil, requestType: RequestType, successed: @escaping (Any)->(), failed: @escaping (Error)->()) {
        
        guard let url = URL(string: baseURL + urlPath.rawValue + appendingPath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if  let parameters = parameters
        {
            let postString = parameters.map({ "\($0.0)=\($0.1)" }).joined(separator: "&")
            request.httpBody = postString.data(using: .utf8)
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    successed(json)
                    print(json)
                } catch {
                    failed(error)
                    print(error)
                }
            }
        }.resume()
    }
    
    
}
