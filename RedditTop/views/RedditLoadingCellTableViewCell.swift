//
//  RedditLoadingCellTableViewCell.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/15/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import UIKit

class RedditLoadingCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLoading: UILabel!
    
    let format = "Cargando %@"
    
    func setListing(_ listing:RedditListing){
        var category : String;
        switch listing {
        case .new:
            category = "nuevos"
        case .rising:
            category = "subiendo"
        case .top:
            category = "popular"
        }
        
        lblLoading.text = String(format:format,category)
    }
    
}
