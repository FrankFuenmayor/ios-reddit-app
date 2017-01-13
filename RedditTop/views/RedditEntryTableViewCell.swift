//
//  RedditEntryTableViewCell.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import UIKit

class RedditEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    func setReddit(entry:RedditEntry) -> Void {
        lblTitle.text = entry.title
        if let thumbnailUrl = entry.thumbnail {
            var request  = URLRequest(url: thumbnailUrl)
            request.httpMethod = "GET"
            
            imgThumbnail.setImageWith(request,
                                      placeholderImage: nil,
                                      success:
                { (req, res, image) in
                
                    self.imgThumbnail.image = image
            }, failure: { (req, res, err) in
                
            });
        }
    }
}
