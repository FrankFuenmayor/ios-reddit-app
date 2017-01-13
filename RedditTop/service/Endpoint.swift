//
//  Endpoint.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation

protocol Endpoint {
    associatedtype EndpointResponseType
    
    var uri : String { get }
    var queryParams : Dictionary<String,String> { get set }
    
    func receive(responseObject:Any?, response:URLResponse?, error:Error?) -> Void
    func getResponse() -> EndpointResponseType
}

enum HttpMethod : String {
    case get = "GET"
}
