//
//  RedditApi.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation
import AFNetworking

class RedditService {
    
    static let service = RedditService()
    
    let baseUrl = "https://www.reddit.com"
    
    let session = URLSession.shared
    let config  = URLSessionConfiguration.default
    
    var manager : AFURLSessionManager {
        return AFURLSessionManager(sessionConfiguration: config)
    }
    
    
    fileprivate init(){        
    }
    
    func request<EndpointType:Endpoint>(endpoint:EndpointType,
                 httpMethod:HttpMethod,
                 completion: @escaping (EndpointType) -> Void) -> URLSessionDataTask{
        
        var url = baseUrl;
        url.append(endpoint.uri)
        url.append("/.json");
        
        let urlComponents = NSURLComponents(string: url)
        
        var queryItems = [URLQueryItem]()
        
        for (name, value) in endpoint.queryParams {
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        
        urlComponents?.queryItems = queryItems;
        
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
