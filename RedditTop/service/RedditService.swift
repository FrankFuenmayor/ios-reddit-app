//
//  RedditApi.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation
import AFNetworking

///Enum para los metodos HTTP
enum HttpMethod : String {
    case get = "GET"
}

/**
 Clase encargada de comunicarse con el API Reddit usando Endpoint para la construccion de
 las solucitudes
*/
class RedditService {
    
    static let service = RedditService()
    
    /**La url esta configurada en el Info.plist y en Build Configuration
     de esta manera se puede establecer distintos valores por configuracion en el proyecto*/
    let baseUrl = Bundle.main.infoDictionary?["RedditBaseUrl"] as! String
    
    
    var manager : AFURLSessionManager {
        return AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    //Init privado para asegurar el singleton
    fileprivate init() {}
    
    /**
     Contruye y ejecuta un request al API con la informacion del endpoint
     */
    func request<EndpointType:Endpoint>(_ endpoint:EndpointType,
                 httpMethod:HttpMethod,
                 completion: @escaping (EndpointType) -> Void) -> URLSessionDataTask{
        
        var url = baseUrl;
        url.append(endpoint.getURI())
        url.append("/.json");
        
        var urlComponents = URLComponents(string: url)
        
        urlComponents?.queryItems = endpoint.getQueryParams().map {URLQueryItem(name: $0, value: $1)}
        
        var req = URLRequest(url: urlComponents!.url!)
        
        req.httpMethod = httpMethod.rawValue
        
        let task = manager.dataTask(with: req) { (urlResponse, responseObject, error) in
            endpoint.receive(responseObject, response: urlResponse, error: error)
            completion(endpoint)
        }
        
        task.resume()
        
        return task;
    }
}
