//
//  RedditEntryTableViewCell.swift
//  RedditTop
//
//  Created by Frank G. Fuenmayor G. on 1/12/17.
//  Copyright © 2017 Frank G. Fuenmayor G. All rights reserved.
//

import UIKit

///Celda utilizada para presentar las distintas entradas en la tabla.
class RedditEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    @IBOutlet weak var lblSubReddit: UILabel!
    @IBOutlet weak var lblComentarios: UILabel!
    
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    let dateFormatter = DateFormatter()
    
    func setReddit(entry:RedditEntry) -> Void {
        
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        
        lblTitle.text = entry.title
        lblAuthor.text = entry.author
        lblComentarios.text = "Comentarios \(entry.commentCount!)"
        lblSubReddit.text = entry.subReddit
        imgThumbnail.image = nil;
        imgWidth.constant = 0
        lblFecha.text = dateFormatter.string(from: entry.creationDate!)
        
        
        
        if let thumbnailUrl = entry.thumbnail {
            imgWidth.constant = 100
            imgThumbnail.setImageWith(thumbnailUrl);
        }
    }
}
