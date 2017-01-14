//
//  RedditRising.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/14/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import Foundation

///Endpoint a la URI /rissing
class RedditRising : RedditEnpoint {
    override func getURI() -> String {
        return "/rising"
    }
}
