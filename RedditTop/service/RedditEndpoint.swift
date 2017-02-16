//
//  RedditTopEndpoint.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation

/**
 Esta clase funciona de base para todos los endpoints usados en la aplicacion
 se encarga de hacer todas las tareas comnunes necesarias
 */
class RedditEnpoint : Endpoint {
    
    ///El tipo de dato esperado en la respuesta
    typealias EndpointResponseType = [RedditEntry]
    
    fileprivate var queryParams : [String:String]
    fileprivate var entries = [RedditEntry]()
    fileprivate var completionHandler : ((EndpointResponseType) -> Void)?
    
    init() {
        queryParams = [:]
    }
    
    ///para la paginacion reddit no usa numero de pagina sino que se hace referencia a una entrada y si se quiere lo que esta antes o despues de la misma
    func after(_ entry:RedditEntry?) {
        if let name = entry?.name {
            queryParams = ["after" : name]
        } else {
            queryParams = [:]
        }
    }
    
    func completion(_ handler: @escaping (EndpointResponseType) -> Void){
        completionHandler = handler
    }
    
    ///Este metodo es el que indica la URI del endpoint, cada endpoint debe sobreecribirlo,
    func getURI() -> String {
        preconditionFailure("Override this method")
    }
    
    func getQueryParams() -> [String : String] {
        return queryParams
    }
    
    func getResponse() -> Array<RedditEntry> {
        return entries;
    }
    
    func receive(_ responseObject: Any?, response: URLResponse?, error: Error?) {
        
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

