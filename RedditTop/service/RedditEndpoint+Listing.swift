//
//  RedditEndpoint+Helper.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/14/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation

enum RedditListing {
    case top
    case new
    case rising
}

extension RedditEnpoint {
    static func endpoint(listing:RedditListing) -> RedditEnpoint {
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



