//
//  RedditApi.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation
import AFNetworking

enum HttpMethod : String {
    case get = "GET"
}

class RedditService {
    
    static let service = RedditService()
    
    let baseUrl = Bundle.main.infoDictionary?["RedditBaseUrl"] as! String
    
    
    var manager : AFURLSessionManager {
        return AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    fileprivate init() {
        
    }
    
    func request<EndpointType:Endpoint>(endpoint:EndpointType,
                 httpMethod:HttpMethod,
                 completion: @escaping (EndpointType) -> Void) -> URLSessionDataTask{
        
        var url = baseUrl;
        url.append(endpoint.getURI())
        url.append("/.json");
        
        let urlComponents = NSURLComponents(string: url)
        
        urlComponents?.queryItems = endpoint.getQueryParams().map {URLQueryItem(name: $0, value: $1)}
        
        var req = URLRequest(url: urlComponents!.url!)
        
        req.httpMethod = httpMethod.rawValue
        
        let task = manager.dataTask(with: req) { (urlResponse, responseObject, error) in
            endpoint.receive(responseObject: responseObject, response: urlResponse, error: error)
            completion(endpoint)
        }
        
        task.resume()
        
        return task;
    }
}
