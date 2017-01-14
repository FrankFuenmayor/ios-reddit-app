//
//  RedditTopEndpoint.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation


class RedditEnpoint : Endpoint {
    
    typealias EndpointResponseType = [RedditEntry]
    
    private var queryParams : [String:String]
    private var entries = [RedditEntry]()
    private var completionHandler : ((EndpointResponseType) -> Void)?
    
    init() {
        queryParams = [:]
    }
    
    func after(entry:RedditEntry?) {
        if let name = entry?.name {
            queryParams = ["after" : name]
        } else {
            queryParams = [:]
        }
    }
    
    func completion(_ handler: @escaping (EndpointResponseType) -> Void){
        completionHandler = handler
    }
    
    func getURI() -> String {
        preconditionFailure("Override this method")
    }
    
    func getQueryParams() -> [String : String] {
        return queryParams
    }
    
    func getResponse() -> Array<RedditEntry> {
        return entries;
    }
    
    func receive(responseObject: Any?, response: URLResponse?, error: Error?) {
        
        //only dictionaries are valid for this endpoint
        guard responseObject is [String:AnyObject] else {
            return
        }
        
        var json = responseObject as! [String:AnyObject]
        if let data = json["data"] as? [String:AnyObject] {            
            if let children = data["children"] as? [[String:AnyObject]] {                
                for entry in children {
                    if let entryData = entry["data"] as? [String:AnyObject] {
                        entries.append(RedditEntry.redditEntry(fromJson: entryData))
                    }
                }
                
                if let handler = completionHandler {
                    handler(entries)
                }
            }
        }
    }
}

