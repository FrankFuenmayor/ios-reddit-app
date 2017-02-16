//
//  RedditEndpoint+Helper.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/14/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation


///Este enum lista los distintos tipos de listados usados en la aplicacion.
enum RedditListing {
    case top
    case new
    case rising
}

/* 
 Con esto se extiende la funcionalidad para facilitar la seleccion del endpoint basado en el enum RedditListing,
 usar un enum y este metodo brinda seguridad de que tenemos endpoint implementados para cada uno de los listadas
 ya que aprovechamos que el switch en swift debe ser exaustivo.
 */
extension RedditEnpoint {
    static func endpoint(_ listing:RedditListing) -> RedditEnpoint {
        switch listing {
        case .top:
            return  RedditTop()
        case .new:
            return RedditNew()
        case .rising:
            return  RedditRising()
        }
    }
}



