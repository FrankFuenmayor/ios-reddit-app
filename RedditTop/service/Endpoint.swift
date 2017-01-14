//
//  Endpoint.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation

/**
 Todos los endpoints deben cumplir con este protocolo
 */
protocol Endpoint {
    
    ///El tipo de dato esperado por el endpoint cuando recibe una respuesta
    associatedtype EndpointResponseType
    
    ///La URI del endpoint, debe comenzar con /
    func getURI() -> String
    
    ///Query params para la construccion de la URL
    func getQueryParams() -> [String:String]
    
    ///Este metodo es llamado por RedditService al recibir la respuesta del API
    func receive(responseObject:Any?, response:URLResponse?, error:Error?) -> Void
    
    ///La respuesta ya convertida al typo deseado
    func getResponse() -> EndpointResponseType
}
