//
//  RedditTopEndpoint.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation

class RedditTopEndpoint : Endpoint {
    
    typealias EndpointResponseType = [RedditEntry]
    
    let uri: String = "/top"
    var queryParams: [String:String]
    var x:Int = 0
    
    private var entries = [RedditEntry]()
    
    init(count:Int?, limit:Int?) {
        queryParams = ["count" : String(count ?? 0),
                       "limit" : String(limit ?? 5)]
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
            }
        }
    }
    
    func getResponse() -> Array<RedditEntry> {
        return entries;
    }
}

